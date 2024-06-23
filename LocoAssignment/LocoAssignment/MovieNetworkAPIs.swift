//
//  MovieNetworkAPIs.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import Foundation

class MovieNetworkAPIs {
    
    /// Function to fetchMovieList API
    /// - Parameters:
    ///   - searchQuery: Search parameter for which the list is to be fetched
    ///   - pageNo: Page No which is being fetched currently
    ///   - completion: closure to pass searchresponse or error
    class func sendGetMovieListRequest(
        searchQuery: String,
        pageNo: Int,
        completion: @escaping (
            _ searchResponse: SearchResponse?,
            _ apiError: Error?
        ) -> ()
    ) {
        let urlString = "https://www.omdbapi.com/?apikey=99eb7d03&s=\(searchQuery)&page=\(pageNo)"
        
        guard let request = NetworkRequest.shared.createRequest(url: urlString, method: .GET)
        else {
            print("error while creating request")
            completion(nil, nil)
            return
        }
        
        NetworkService.shared.makeRequest(request: request) { (data, response, error) in
            guard let err = error else {
                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        print("data obtained is nil")
                        completion(nil, nil)
                    }
                    return
                }
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(searchResponse, nil)
                    }
                    return
                }
                catch let tryError {
                    print(tryError)
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(nil, err)
            }
        }
    }
    
    /// API call to fetch details for a particular movie
    /// - Parameters:
    ///   - imdbId: imdbID for that movie
    ///   - completion: closure to take action on response received from the API
    class func senGetMovieInfoRequest(
        imdbId: String,
        completion: @escaping (
            _ searchResponse: MovieScreenInfo?,
            _ apiError: Error?
        ) -> ()
    ) {
        let urlString = "https://www.omdbapi.com/?apikey=99eb7d03&i=\(imdbId)"
        
        guard let request = NetworkRequest.shared.createRequest(url: urlString, method: .GET)
        else {
            print("error while creating request")
            completion(nil, nil)
            return
        }
        
        NetworkService.shared.makeRequest(request: request) { (data, response, error) in
            guard let err = error else {
                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        print("data obtained is nil")
                        completion(nil, nil)
                    }
                    return
                }
                do {
                    let movieInfo = try JSONDecoder().decode(MovieScreenInfo.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(movieInfo, nil)
                    }
                    return
                }
                catch let tryError {
                    print(tryError)
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(nil, err)
            }
        }
    }
}
