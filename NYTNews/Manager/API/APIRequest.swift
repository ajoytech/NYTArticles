//
//  APIRequest.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 24/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

class APIRequest {
    //HTTP methods
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    /**
     This method returns URLRequest from provided URL, method, query items and other config params
     - Parameters:
     - url: URL for fetch/search article API
     - method: http method type
     - queryDict: query params
     - cachePolicy: cache policy to apply
     - timeOut: Time out period for API request
     - Returns:
     - URLRequest: url request
     */
    static func buildArticleRequest(url: URL, method: HTTPMethod, queryDict: [String: String], cachePolicy:
        URLRequest.CachePolicy = .useProtocolCachePolicy, timeout: TimeInterval = 60) -> URLRequest? {
        var queryItems: [URLQueryItem] = []
        for query in queryDict {
            let item = URLQueryItem(name: query.key, value: query.value)
            queryItems.append(item)
        }
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = queryItems
        guard let finalUrl = urlComponent?.url else { return nil }
        
        var urlRequest = URLRequest(url: finalUrl, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    /**
     This method returns URLRequest from provided URL, method, query items and other config params for download image
     - Parameters:
     - imageUrl: URL for fetch/search article API
     - method: http method type
     - queryDict: query params
     - cachePolicy: cache policy to apply
     - timeOut: Time out period for API request
     - Returns:
     - URLRequest: request object
     */
    static func buildImageRequest(imageUrl: URL, method: HTTPMethod = .GET, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeOut: TimeInterval = 60) -> URLRequest? {
        var urlRequest = URLRequest(url: imageUrl, cachePolicy: cachePolicy, timeoutInterval: timeOut)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
