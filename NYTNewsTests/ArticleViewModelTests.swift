//
//  ArticleViewModelTests.swift
//  PGArticlesTests
//
//  Created by Ajoy Kumar on 10/08/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import XCTest
@testable import NYTNews

class ArticleViewModelTests: XCTestCase {

    var errorCaseArticleViewModel: ArticleViewModel!
    var apiManagerErrorCase: MockErrorCaseAPIManager!
    
    override func setUp() {
        apiManagerErrorCase = MockErrorCaseAPIManager()
        errorCaseArticleViewModel = ArticleViewModel(networkManager: apiManagerErrorCase)
    }

    override func tearDown() {
        errorCaseArticleViewModel = nil
        apiManagerErrorCase = nil
    }
    
    func testZeroArticles() {
        errorCaseArticleViewModel.fetchArticles()
        XCTAssertEqual(errorCaseArticleViewModel.currentArticleCount, 0)
    }

    func testZeroSearchArticleResult() {
        errorCaseArticleViewModel.searchArticles("singapore")
        XCTAssertEqual(errorCaseArticleViewModel.currentArticleCount, 0)
    }
    
    func testFetchArticleReturnedError() {
        errorCaseArticleViewModel.fetchArticles()
        errorCaseArticleViewModel.listener = { (error, indexPathList) in
            XCTAssertEqual(error?.type, .RemoteServiceReturnedNilData)
        }
    }
    
    func testSearchArticleReturnedError() {
        errorCaseArticleViewModel.searchArticles("test")
        errorCaseArticleViewModel.listener = { (error, indexPathList) in
            XCTAssertEqual(error?.type, .RemoteServiceReturnedNilData)
        }
    }
    
    func testImageDownloadReturnedError() {
        let imageView = UIImageView()
        imageView.setImage(from: "nyt/test.png")
        errorCaseArticleViewModel.listener = { (error, indexPathList) in
            XCTAssertEqual(error?.type, .RemoteServiceReturnedNilData)
        }
    }
}


class MockErrorCaseAPIManager: APIManagerProtocol {

    func fetchArticles(page: Int, completion: @escaping ArticleCompletionBlock) {
        completion(.failed(CustomError(type: .RemoteServiceReturnedNilData)))
    }
    
    func searchArticles(searchKey: String, completion: @escaping ArticleCompletionBlock) {
        completion(.failed(CustomError(type: .RemoteServiceReturnedNilData)))
    }
    
    func downloadArticleImages(relativePath: String, completion: @escaping DownloadImageCompletionBlock) {
    }
    
    
}
