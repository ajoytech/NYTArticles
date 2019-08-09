//
//  SearchResultViewController.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 25/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import UIKit

protocol SearchArticleProtocol: class {
    func searchArticle(with selectedKey: String)
}

class SearchResultViewController: UITableViewController {

    var dataSource: [String] = []
    weak var searchDelegate: SearchArticleProtocol?
    
    init(delegate: SearchArticleProtocol) {
        super.init(style: .plain)
        searchDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchDelegate?.searchArticle(with: dataSource[indexPath.row])
    }

}
