//
//  ArticleListViewController.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController {

    @IBOutlet weak var articleListView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var searchKeyList: [String] = []
    lazy var viewModel: ArticleViewModel = {
        return ArticleViewModel()
    }()
    lazy private var searchBarController = {
        return UISearchController(searchResultsController: SearchResultViewController(delegate: self))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleListView.rowHeight = UITableView.automaticDimension
        articleListView.estimatedRowHeight = 300
        self.title = "NYT News"
        
       searchKeyList.reserveCapacity(2)
        //ViewModel listener
        viewModel.listener = { [weak self] (error, indexPathList) in
            
            if let error = error {
                RunOnMainThread {
                    self?.activityIndicator.stopAnimating()
                    self?.showAlertWith(error.description ?? "Oops! some error occured, please try again.")
                }
            }else {
                RunOnMainThread {
                    self?.searchBarController.searchResultsController?.view.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    if let indexList = indexPathList {
                        guard let reloadIndexes = self?.indexPathsToReload(indexList) else { return }
                        self?.articleListView.beginUpdates()
                        self?.articleListView.reloadRows(at: reloadIndexes, with: .bottom)
                        self?.articleListView.endUpdates()
                    }else {
                        self?.articleListView.reloadData()
                    }
                }
            }
        }
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        viewModel.fetchArticles()
        
        //search bar
        searchBarController.obscuresBackgroundDuringPresentation = true
        searchBarController.searchBar.placeholder = "search articles here..."
        searchBarController.searchBar.delegate = self
        searchBarController.delegate = self
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBarController.isActive = true
    }

    
    private func showAlertWith(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentArticles()
    }
    
    func indexPathsToReload(_ indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = articleListView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func isSearching() -> Bool {
        return !(searchBarController.searchResultsController?.view.isHidden ?? true)
    }
}

//MARK: Table view datasource
extension ArticleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalArticles()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleCell = tableView.dequeueReusableCell(withIdentifier: "articleListCell", for: indexPath) as? ArticleViewCell else { return UITableViewCell() }
        
        if isLoadingCell(for: indexPath) {
            articleCell.setData(with: nil)
        }else {
            let dataViewModel = viewModel.getModel(index: indexPath.row)
            articleCell.setData(with: dataViewModel)
        }
        return articleCell
        
    }
}

//MARK: Table view delegate
extension ArticleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.currentArticles() - 1 {
            RunInBackground {
                self.viewModel.fetchArticles()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedViewModel = viewModel.getModel(index: indexPath.row)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let articleDetailController = storyBoard.instantiateViewController(withIdentifier: "articleDetailsVC") as? ArticleDetailViewController else {
            showAlertWith("Error in loading article detail view controller")
            return
        }
        articleDetailController.articleImageUrl = selectedViewModel?.imageLink
        articleDetailController.articleTitle = selectedViewModel?.title
        articleDetailController.articleDetail = selectedViewModel?.description
        self.navigationController?.pushViewController(articleDetailController, animated: true)
    }
}

//MARK: UISearchBar delegate
extension ArticleListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !(searchKeyList.contains(text)) {
                if searchKeyList.count == 2 {
                    _ = searchKeyList.removeLast()
                }
                searchKeyList.insert(text, at: 0)
            }
            viewModel.searchArticles(text)
            RunOnMainThread {
                self.activityIndicator.startAnimating()
                self.searchBarController.searchResultsController?.view.isHidden = true
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        RunOnMainThread {
            self.searchBarController.searchResultsController?.view.isHidden = true
        }
        if isSearching() {
            viewModel.currentArticlePage = 1
            viewModel.fetchArticles()
        }
    }
    
}

//MARK: UISearchControllerDelegate delegate
extension ArticleListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        RunOnMainThread {
            searchController.searchResultsController?.view.isHidden = false
            let sc = searchController.searchResultsController as! SearchResultViewController
            sc.dataSource = self.searchKeyList
            sc.tableView.reloadData()
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}

//MARK: SearchKeyProtocol delegate
extension ArticleListViewController: SearchKeyProtocol {
    func searchArticle(with selectedKey: String) {
        print("Search from selected key:: \(selectedKey)")
        viewModel.searchArticles(selectedKey)
        RunOnMainThread {
            self.activityIndicator.startAnimating()
            self.searchBarController.searchResultsController?.view.isHidden = true
        }
    }
}
