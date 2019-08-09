//
//  APIManager.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

typealias ArticleCompletionBlock = (Result<ArticleResponse, CustomError>) -> Void

//API Result type declaration
enum Result<T, E: Error> {
    case success(T)
    case failed(E)
}

//API MAnager protocol to define method requirements
protocol APIManagerProtocol {
    func fetchArticles(page: Int, completion: @escaping ArticleCompletionBlock)
    func searchArticles(searchKey: String, completion: @escaping ArticleCompletionBlock)
    func downloadArticleImages(relativePath: String, completion: @escaping (Result<Data, CustomError>) -> Void)
}

class APIManager: APIResponseHandler, APIManagerProtocol {
    
    static let shared = APIManager()
    private var task: URLSessionTask?
    private var imageTask: URLSessionTask?
    
    /**
     This method will download articles of the sepcified page from nyt
     - Parameters:
     - page: page number to download from backend
     - completion: callback closure
     - Returns:
     */
    func fetchArticles(page: Int, completion: @escaping ArticleCompletionBlock) {
        print("Calling page :: \(page)")
        APITask.getArticleTask(urlString: APIConfiguration.articleSearchBaseUrl, queryParameters: ["api-key": APIConfiguration.tokenKey, "page": String(page)], completion: APIResponseHandler.handleArticleResult(completion: completion))
        
    }
    
    /**
     This method will search articles based on passed searhKey from nyt
     - Parameters:
     - searchKey: search key to search articles based on key
     - completion: callback closure
     - Returns:
     */
    func searchArticles(searchKey: String, completion: @escaping ArticleCompletionBlock) {
        APITask.getArticleTask(urlString: APIConfiguration.articleSearchBaseUrl, queryParameters: ["api-key": APIConfiguration.tokenKey, "q": searchKey], completion: APIResponseHandler.handleArticleResult(completion: completion))
    }
    
    
    /**
     This will download the image from specified URL
     - Parameters:
     - url: Url string
     - completion: callback closure
     - Returns:
     */
    func downloadArticleImages(relativePath: String, completion: @escaping (Result<Data, CustomError>) -> Void) {
        APITask.downloadImageTask(urlString: APIConfiguration.imageBaseUrl, pathComponent: relativePath, completion: APIResponseHandler.handleImageDownloadResult(completion: completion))
    }
}
