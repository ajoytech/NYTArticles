
//
//  ArticleViewModel.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

typealias viewModelListener = ((CustomError?, [IndexPath]?) -> Void)

class ArticleViewModel {
    private var apiManager: APIManagerProtocol
    private var dataModel: [ArticleCellViewModel]!
    private var isCallInProgress: Bool = false
    private var total: Int = 0
    var currentArticlePage: Int = 1
    var listener: viewModelListener?
    var currentArticleCount: Int {
        return dataModel?.count ?? 0
    }
    var totalArticlesCount: Int {
        return total
    }
    
    init(networkManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = networkManager
        
    }
    
    public func searchArticles(_ searchKey: String) {
        guard !isCallInProgress else { return }
        isCallInProgress = true
        print("calling search article :: \(searchKey)")
        apiManager.searchArticles(searchKey: searchKey) { [weak self] (result) in
            guard let self = self else { return }
            self.isCallInProgress = false
            switch result {
                case .success(let data) :
                    let dataModel = self.buildArticleCellModel(data.response.articles)
                    self.dataModel = dataModel
                    self.listener?(.none, .none)
                case .failed(let error) :
                    self.listener?(error, nil)
            }
        }
    }
    
    public func fetchArticles() {
        guard !isCallInProgress else { return }
        isCallInProgress = true
        RunInBackground {
            self.apiManager.fetchArticles(page: self.currentArticlePage) { [weak self] (result) in
                guard let self = self else { return }
                self.isCallInProgress = false
                switch result {
                    case .success(let data) :
                        self.currentArticlePage += 1
                        self.total = self.total == 0 ? data.response.pageInfo.total : self.total
                        let cellModel = self.buildArticleCellModel(data.response.articles)
                        if self.currentArticlePage > 2,
                            let model = self.dataModel {
                            self.dataModel.append(contentsOf: model)
                            self.listener?(nil, self.indexPathToReload(cellModel.count))
                        }else {
                            self.dataModel = cellModel
                            self.listener?(.none, .none)
                        }
                    case .failed(let error) :
                        self.listener?(error, nil)
                }
            }
        }
    }
    
    private func buildArticleCellModel(_ articles: [Article]) -> [ArticleCellViewModel] {
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
    
    
    public func articleCellViewModel(at index: Int) -> ArticleCellViewModel? {
        return dataModel?[index]
    }
}
