//
//  CustomErrorTests.swift
//  PGArticlesTests
//
//  Created by Ajoy Kumar on 26/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import XCTest
@testable import NYTNews

class CustomErrorTests: XCTestCase {
    
    func testInvalidInputErrorDescription() {
        let error = CustomError(type: .InvalidInput)
        XCTAssertTrue(error.description == "A method parameter is invalid, or an object status is invalid")
    }
    
    func testInvalidResponseErrorDescription() {
        let error = CustomError(type: .InvalidResponse)
        XCTAssertTrue(error.description == "A network call has returned invalid response")
    }
    
    func testInvalidResponseErrorType() {
        let error = CustomError(type: .InvalidResponse)
        XCTAssertTrue(error.type == .InvalidResponse)
    }
    
    func testMissingURLErrorDescription() {
        let error = CustomError(type: .MissingBaseURL)
        XCTAssertTrue(error.description == "The base URL is found nil")
    }
    
    func testMissingURLErrorType() {
        let error = CustomError(type: .MissingBaseURL)
        XCTAssertTrue(error.type == .MissingBaseURL)
    }
    
    func testMissingAPIKeyErrorDescription() {
        let error = CustomError(type: .MissingAPIKey)
        XCTAssertTrue(error.description == "API key for accessig APIs is missing")
    }
    
    func testMissingAPIKeyErrorType() {
        let error = CustomError(type: .MissingAPIKey)
        XCTAssertTrue(error.type == .MissingAPIKey)
    }
    
    func testRemoteServiceFailedErrorDescription() {
        let error = CustomError(type: .RemoteServiceFailed)
        XCTAssertTrue(error.description == "A remote service has failed")
    }
    
    func testRemoteServiceFailedErrorType() {
        let error = CustomError(type: .RemoteServiceFailed)
        XCTAssertTrue(error.type == .RemoteServiceFailed)
    }
    
    func testCannotDecodeDataErrorDescription() {
        let error = CustomError(type: .CannotDecodeData)
        XCTAssertTrue(error.description == "Cannot decode data buffer")
    }
    
    func testCannotDecodeDataErrorType() {
        let error = CustomError(type: .CannotDecodeData)
        XCTAssertTrue(error.type == .CannotDecodeData)
    }
    
    func testNoInternetErrorDescription() {
        let error = CustomError(type: .NoInternet)
        XCTAssertTrue(error.description == "There is no internet connection")
    }
    
    func testNoInternetErrorType() {
        let error = CustomError(type: .NoInternet)
        XCTAssertTrue(error.type == .NoInternet)
    }
    
    func testUnknownErrorDescription() {
        let error = CustomError(type: .Unknown)
        XCTAssertTrue(error.description == "An unknown error has occurred")
    }
    
    func testUnknownErrorType() {
        let error = CustomError(type: .Unknown)
        XCTAssertTrue(error.type == .Unknown)
    }
    
    func testServiceReturnedNilDataDescription() {
        let error = CustomError(type: .RemoteServiceReturnedNilData)
        XCTAssertTrue(error.description == "A service call was ok but data is nil")
    }
    
    func testServiceReturnedNilDataType() {
        let error = CustomError(type: .RemoteServiceReturnedNilData)
        XCTAssertTrue(error.type == .RemoteServiceReturnedNilData)
    }
    
    func testErrorLocalizedDescription() {
        let error = CustomError(type: .Unknown)
        XCTAssertTrue(error.localizedDescription == " An unknown error has occurred")
    }
    
    func testErrorDebugDescription() {
        let error = CustomError(type: .Unknown)
        XCTAssertTrue(error.debugDescription == " An unknown error has occurred\nInner Error: nil")
    }
    
    func testErrorCustomDescription() {
        let description = "A description"
        let error = CustomError(type: .InvalidInput, description: description)
        XCTAssertTrue(error.description == description)
    }
    
}
