
//
//  ArticleViewModel.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

typealias ModelUpdated = ((CustomError?, [IndexPath]?) -> Void)

class ArticleViewModel {
    private var apiManager: APIManagerProtocol
    private var dataModel: [ArticleCellViewModel]!
    private var isCallInProgress: Bool = false
    private var total: Int = 0
    var currentArticlePage: Int = 1
    var listener: ModelUpdated?
    
    init(networkManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = networkManager
        
    }
    
    public func searchArticles(_ searchKey: String) {
        guard !isCallInProgress else { return }
        isCallInProgress = true
        print("calling search article :: \(searchKey)")
        apiManager.searchArticles(searchKey: searchKey) { [weak self] (result) in
            self?.isCallInProgress = false
            switch result {
            case .success(let data) :
                guard let dataModel = self?.buildArticleCellModel(articles: data.response.articles) else { return }
                self?.dataModel = dataModel
                self?.listener?(.none, .none)
            case .failed(let error) :
                self?.listener?(error, nil)
            }
        }
    }
    
    public func fetchArticles() {
        guard !isCallInProgress else { return }
        isCallInProgress = true
        RunInBackground {
            self.apiManager.fetchArticles(page: self.currentArticlePage) { [weak self] (result) in
                self?.isCallInProgress = false
                switch result {
                    case .success(let data) :
                        self?.currentArticlePage += 1
                        self?.total = self?.total == 0 ? data.response.pageInfo.total : (self?.total)!
                        guard let dataModel = self?.buildArticleCellModel(articles: data.response.articles) else { return }
                        if let page = self?.currentArticlePage,
                            page > 2,
                            let model = self?.dataModel {
                            self?.dataModel.append(contentsOf: model)
                            self?.listener?(nil, self?.indexPathToReload(dataModel.count))
                        }else {
                            self?.dataModel = dataModel
                            self?.listener?(.none, .none)
                        }
                    case .failed(let error) :
                        self?.listener?(error, nil)
                }
            }
        }
    }
    
    private func buildArticleCellModel(articles: [Article]) -> [ArticleCellViewModel] {
        var articleCellModel: [ArticleCellViewModel] = []
        
        for article in articles {
            articleCellModel.append(ArticleCellViewModel(article))
        }
        return articleCellModel
    }
    
    private func indexPathToReload(_ freshArticlesCount: Int) -> [IndexPath] {
        let startIndex = dataModel.count - freshArticlesCount
        let endIndex = startIndex + freshArticlesCount
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    public func currentArticles() -> Int {
        return dataModel?.count ?? 0
    }
    
    public func totalArticles() -> Int {
        return total
    }
    
    public func getModel(index: Int) -> ArticleCellViewModel? {
        return dataModel?[index]
    }
}
