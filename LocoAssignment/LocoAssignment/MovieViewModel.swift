//
//  MovieViewModel.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import Foundation

class MovieViewModel {
    
    var pageCount = 1
    var endReached = false
    var movieInfo: MovieScreenInfo?
    var movieList: [MovieDetails] = []
    
    /// Call the movieAPI along with list manipulation for pagination
    /// - Parameters:
    ///   - searchQuery: Search string for the movie
    ///   - shouldResetPage: Pagecount and list to be reset when calling new search paramter
    ///   - completion: closure to pass the error if any
    func callSearchMovieApi(searchQuery: String, shouldResetPage: Bool, completion: @escaping ( _ apiError: Error?) -> ()) {
        if shouldResetPage {
            self.pageCount = 1
            self.movieList = []
            self.endReached = false
        }
        MovieNetworkAPIs.sendGetMovieListRequest(searchQuery: searchQuery, pageNo: self.pageCount) { searchResponse, error in
            guard let err = error else {
                self.movieList.append(contentsOf: (searchResponse?.movies ?? []))
                self.pageCount += 1
                if self.movieList.count == (Int(searchResponse?.totalResults ?? "") ?? -1) {
                    self.endReached = true
                }
                completion(nil)
                return
            }
            completion(err)
        }
    }
    
    /// Function to call the API for fetching the details of a particular movie
    /// - Parameters:
    ///   - imdbID: ID of the movie
    ///   - completion: closure to pass the error if any
    func callMovieInfoApi(imdbID: String, completion: @escaping ( _ apiError: Error?) -> ()) {
        MovieNetworkAPIs.senGetMovieInfoRequest(imdbId: imdbID) { movieInfo, error in
            guard let err = error else {
                self.movieInfo = movieInfo
                completion(nil)
                return
            }
            completion(err)
        }
    }
}
