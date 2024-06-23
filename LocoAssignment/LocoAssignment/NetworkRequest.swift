//
//  NetworkRequest.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import Foundation

class NetworkRequest {
    
    private static var privateShared: NetworkRequest?
    
    class var shared: NetworkRequest {
        guard let existingShared = NetworkRequest.privateShared else {
            let newShared = NetworkRequest()
            NetworkRequest.privateShared = newShared
            return newShared
        }
        return existingShared
    }
    
    let networkRequestTimeOut: TimeInterval = 45
    
    /// This function is used to make network requests
    /// - Parameters:
    ///   - url: Url which is to be called
    ///   - method: Request method - GET/PUT/POST/DELETE
    ///   - requestObject: Request object which conforms to encodable
    ///   - requestDict: Request object in form of a dictionary
    /// - Returns: URLRequest
    func createRequest(
        url: String,
        method: RequestMethod,
        requestObject: Encodable? = nil,
        requestDict: [String: Any]? = nil
    ) -> URLRequest? {
        do {
            var urlRequest = try self.createBaseRequest(url: url, method: method)
            
            switch method {
                case .GET, .DELETE:
                    break
                case .PUT, .POST:
                    if let reqObj = requestObject {
                        urlRequest.httpBody = try JSONEncoder().encode(reqObj)
                    }
                    else if let reqDict = requestDict {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: reqDict)
                    }
            }
            
            return urlRequest
        } catch let requestCreationError {
            print(requestCreationError)
            return nil
        }
    }
    
    fileprivate func createBaseRequest(
        url: String,
        method: RequestMethod
    ) throws -> URLRequest {
        
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            throw RequestCreationError.percentEncodingFailed
        }
        guard let urlObject = URL(string: urlString)
        else {
            throw RequestCreationError.urlObjectCreationFailed
        }
        var urlRequest = URLRequest(url: urlObject, timeoutInterval: self.networkRequestTimeOut)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

enum RequestCreationError: Error {
    case percentEncodingFailed
    case urlObjectCreationFailed
}

enum RequestMethod: String {
    case GET, PUT, POST, DELETE
}
