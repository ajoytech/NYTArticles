//
//  ArticleCellModel.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 24/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

struct ArticleCellViewModel {
    var imageLink: String?
    var title: String?
    var description: String?
    var date: String?
    
    init(_ article: Article) {
        self.imageLink = article.url ?? ""
        self.title = article.title
        self.description = article.detailedNews
    }
}

extension ArticleCellViewModel: Equatable {
    static func ==(lhs: ArticleCellViewModel, rhs: ArticleCellViewModel) -> Bool {
        return lhs.imageLink == rhs.imageLink || lhs.date == rhs.date
    }
}
