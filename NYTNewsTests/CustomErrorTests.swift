//
//  CustomErrorTests.swift
//  PGArticlesTests
//
//  Created by Ajoy Kumar on 26/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import XCTest
@testable import PGArticles

class CustomErrorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func testError(error: CustomError) {
        //This switch is to make sure all the errors are tested
        switch error.type {
            case .InvalidInput: XCTAssertTrue(error.description == "A method parameter is invalid, or an object status is invalid")
            case .InvalidResponse: XCTAssert(error.description == "A network call has returned invalid response")
            case .MissingBaseURL: XCTAssert(error.description == "The base URL is found nil")
            case .MissingAPIKey: XCTAssert(error.description == "API key for accessig APIs is missing")
            case .RemoteServiceFailed: XCTAssertTrue(error.description == "A remote service has failed")
            case .CannotDecodeData: XCTAssertTrue(error.description == "Cannot decode data buffer")
            case .NoInternet: XCTAssertTrue(error.description == "There is no internet connection")
            case .Unknown: XCTAssertTrue(error.description == "An unknown error has occurred")
            case .RemoteServiceReturnedNilData: XCTAssertTrue(error.description == "A service call was ok but data is nil")
        }
    }
    
    func testCustomErrorValues() {
        
        let description = "A description"
        var error = CustomError(type: .InvalidInput, description: description)
        XCTAssertTrue(error.type == .InvalidInput)
        XCTAssertTrue(error.description == description)
        
        error = CustomError(type: .InvalidResponse)
        XCTAssertTrue(error.type == .InvalidResponse)
        testError(error: error)
        
        error = CustomError(type: .MissingBaseURL)
        XCTAssertTrue(error.type == .MissingBaseURL)
        testError(error: error)
        
        error = CustomError(type: .MissingAPIKey)
        XCTAssertTrue(error.type == .MissingAPIKey)
        testError(error: error)
        
        error = CustomError(type: .RemoteServiceFailed)
        XCTAssertTrue(error.type == .RemoteServiceFailed)
        testError(error: error)
        
        error = CustomError(type: .CannotDecodeData)
        XCTAssertTrue(error.type == .CannotDecodeData)
        testError(error: error)
        
        error = CustomError(type: .NoInternet)
        XCTAssertTrue(error.type == .NoInternet)
        testError(error: error)
        
        error = CustomError(type: .Unknown)
        XCTAssertTrue(error.type == .Unknown)
        testError(error: error)
        
        XCTAssertTrue(error.localizedDescription == " An unknown error has occurred")
        XCTAssertTrue(error.debugDescription == " An unknown error has occurred\nInner Error: nil")
    }
    
}
