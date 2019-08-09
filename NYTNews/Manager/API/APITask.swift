//
//  APITask.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 24/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

struct APITask {
    
    /**
     This method will create URLSession task for fetching/searching articles
     - Parameters:
     - urlString: url string for article API
     - queryParameters: required query parameters for article fetch/search
     - session: URLSession configuration, default to default configuration
     - completion: callback closure
     - Returns:
     - url session: URLSession
     */
    static func getArticleTask(
            urlString: String,
            queryParameters: [String: String],
            session: URLSession = URLSession(configuration: .default),
            completion: @escaping (Result<Data, CustomError>) -> Void
        ) {
        
        guard let url = URL(string: urlString) else {
            completion(.failed(CustomError(type: .MissingBaseURL)))
            return
        }
        
        guard let request = APIRequest.buildArticleRequest(url: url, method: .GET, queryDict: queryParameters) else {
            completion(.failed(CustomError(type: .InvalidInput)))
            return
        }
        RunInBackground {
            let articleTask = session.dataTask(with: request) { (data, response, error) in
                //check if error
                if let apiError = error as NSError? {
                    completion(.failed(CustomError(error: apiError)))
                    return
                }
                
                //check if data present
                if let data = data {
                    completion(.success(data))
                }else {
                    completion(.failed(CustomError(type: .RemoteServiceReturnedNilData)))
                }
            }
            articleTask.resume()
        }
        
    }
    
    
    /**
     This method will create URLSession task for downloading image for article item
     - Parameters:
     - urlString: url string for article API
     - pathComponent: path component to append into url string
     - session: URLSession configuration, default to default configuration
     - completion: callback closure
     - Returns:
     - url session: URLSession
     */
    static func downloadImageTask(
            urlString: String,
            pathComponent: String,
            session: URLSession = URLSession(configuration: .default),
            completion: @escaping (Result<Data, CustomError>) -> Void
        ) {
        
        guard var url = URL(string: urlString) else {
            completion(.failed(CustomError(type: .MissingBaseURL)))
            return
        }
        url = url.appendingPathComponent(pathComponent)
        guard let request = APIRequest.buildImageRequest(imageUrl: url) else {
            completion(.failed(CustomError(type: .InvalidInput)))
            return
        }
        RunInBackground {
            let articleTask = session.dataTask(with: request) { (data, response, error) in
                //check if error
                if let apiError = error as NSError? {
                    completion(.failed(CustomError(error: apiError)))
                    return
                }
                //check if data present
                if let data = data {
                    completion(.success(data))
                }else {
                    completion(.failed(CustomError(type: .RemoteServiceReturnedNilData)))
                }
            }
            articleTask.resume()
        }
    }
}
