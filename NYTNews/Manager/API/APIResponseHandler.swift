//
//  APIResponseHandler.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 24/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

class APIResponseHandler {
    /**
     This is response data handler for article API method which takes generic data model
     - Parameters:
     - completion: callback closure
     - Returns:
     - completion: callback closure
     */
    static func handleArticleResult<T: Codable>(completion: @escaping (Result<T, CustomError>) -> Void) ->  ((Result<Data, CustomError>) -> Void) {
        
        return { result in
            RunInBackground {
                switch result {
                case .success(let data) :
                    do {
                        let articles = try JSONDecoder().decode(ArticleResponse.self, from: data) as! T
                        completion(Result.success(articles))
                        
                    }catch let error {
                        print(error)
                        completion(Result.failed(CustomError(type: .CannotDecodeData)))
                    }
                case .failed(let error) :
                    completion(.failed(error))
                }
            }
            
        }
    }
    
    
    /**
     This is response data handler method for downloading image which takes generic data model
     - Parameters:
     - completion: callback closure
     - Returns:
     - completion: callback closure
     */
    static func handleImageDownloadResult<T: Codable>(completion: @escaping (Result<T, CustomError>) -> Void) ->  ((Result<Data, CustomError>) -> Void) {
        
        return { result in
            RunInBackground {
                switch result {
                case .success(let data) :
                    do {
                        let data = data as! T
                        completion(.success(data))
                        
                    }catch let error {
                        print(error)
                        completion(.failed(CustomError(type: .CannotDecodeData)))
                    }
                case .failed(let error) :
                    completion(.failed(error))
                }
            }
            
        }
    }
}
