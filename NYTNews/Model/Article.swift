//
//  Article.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

//Article API data models
struct Article: Codable {
    let head: Headline?
    let detailedNews: String?
    let image: [Media]?
    let pubDate: String?
    
    enum CodingKeys: String, CodingKey {
        case head = "headline"
        case detailedNews = "snippet"
        case image = "multimedia"
        case pubDate = "pub_date"
    }
    
    var url: String? {
        return (image?.filter { $0.subType == "xlarge"})?.first?.url
    }
    var title: String? {
        return head?.main
    }
}

struct Articles: Codable {
    let articles: [Article]
    let pageInfo: MetaInfo
    
    enum CodingKeys: String, CodingKey {
        case articles = "docs"
        case pageInfo = "meta"
    }
}

struct ArticleResponse: Codable {
    let response: Articles
}

struct MetaInfo: Codable {
    let number: Int
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case number = "offset"
        case total = "hits"
    }
}

struct Headline: Codable {
    var main: String?
}

struct Media: Codable {
    let url: String?
    let subType: String?
}
