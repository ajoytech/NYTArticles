//
//  SearchResultViewController.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 25/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import UIKit

protocol SearchKeyProtocol: class {
    func searchArticle(with selectedKey: String)
}

class SearchResultViewController: UITableViewController {

    var dataSource: [String] = []
    weak var searchRCDelegate: SearchKeyProtocol?
    
    init(delegate: SearchKeyProtocol) {
        super.init(style: .plain)
        searchRCDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading search result")
        print(dataSource)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchRCDelegate?.searchArticle(with: dataSource[indexPath.row])
    }

}
