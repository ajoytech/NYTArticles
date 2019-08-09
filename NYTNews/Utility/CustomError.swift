//
//  CustomError.swift
//  PGArticles
//
//  Created by Ajoy Kumar on 23/07/19.
//  Copyright © 2019 Ajoy Kumar. All rights reserved.
//

import Foundation

struct CustomError: Error, CustomErrorProtocol {
    var type: ErrorType
    
    var title: String
    
    var description: String?
    
    public var innerError: NSError? = nil
    
    public var debugDescription: String {
        let localizedDescription = self.localizedDescription
        let innerError = "\nInner Error: " + self.innerError.debugDescription
        return localizedDescription + innerError
    }
    
    public var localizedDescription: String {
        let titl = NSLocalizedString(title, comment: "")
        let desc = NSLocalizedString(description ?? "", comment: "")
        
        return titl + " " + desc
    }
    
    public init(type: ErrorType, title: String = "", description: String? = nil) {
        self.type = type
        self.description = description ?? type.description()
        self.title = title
    }
    
    public init(error: NSError) {
        var type : ErrorType = .Unknown
        switch (Int32(error.code), error.domain) {
        case (CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue, "NSURLErrorDomain") : type = .NoInternet
        default: type = .Unknown
        }
        self.init(type: type)
        innerError = error
    }
}

//Error attribute requirement
protocol CustomErrorProtocol {
    var title: String { get }
    var description: String? { get }
    var type: ErrorType { get }
}

//different custom error types
enum ErrorType: Int {
    case InvalidInput
    case InvalidResponse
    case MissingBaseURL
    case MissingAPIKey
    case RemoteServiceFailed
    case RemoteServiceReturnedNilData
    case CannotDecodeData
    case NoInternet
    case Unknown
    
    func description() -> String {
        switch self {
        case .InvalidInput: return "A method parameter is invalid, or an object status is invalid"
        case .InvalidResponse: return "A network call has returned invalid response"
        case .MissingBaseURL: return "The base URL is found nil"
        case .MissingAPIKey: return "API key for accessig APIs is missing"
        case .RemoteServiceFailed: return "A remote service has failed"
        case .RemoteServiceReturnedNilData: return "A service call was ok but data is nil"
        case .CannotDecodeData: return "Cannot decode data buffer"
        case .NoInternet: return "There is no internet connection"
        case .Unknown: return "An unknown error has occurred"
        }
    }
}
