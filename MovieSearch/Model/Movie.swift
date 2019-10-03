//
//  Movie.swift
//  MovieSearch
//
//  Created by Michael Flowers on 10/3/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
//// apikey:  3021207a0f44385e84ef7cc905fb9320
///  baseURL: https://api.themoviedb.org/3/search/movie?api_key=3021207a0f44385e84ef7cc905fb9320&query=Jack+Reacher
struct MovieSearch: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let rating: Double
    let summary: String
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case rating = "vote_average"
        case summary = "overview"
        case poster = "poster_path"
    }
}
