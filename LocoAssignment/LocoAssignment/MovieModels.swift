//
//  SearchModels.swift
//  LocoAssignment
//
//  Created by Arav Khandelwal on 22/06/24.
//

import Foundation

struct SearchResponse: Codable {
    let movies: [MovieDetails]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}

struct MovieDetails: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

struct MovieScreenInfo: Codable {
    let title: String
    let released: String
    let director: String
    let plot: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case released = "Released"
        case director = "Director"
        case plot = "Plot"
        case poster = "Poster"
    }
}
