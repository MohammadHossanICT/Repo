//
//  Movie.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation

struct Movie: Decodable {
    let originalTitle: String
    let overview: String
    let posterPath: String

    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
    }
    
    init(originalTitle: String, overview: String, posterPath: String) {
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
    }
    init(_ cdMovie : CDMovie){
        originalTitle = cdMovie.originalTitle ?? ""
        overview = cdMovie.overview ?? ""
        posterPath = cdMovie.posterPath ?? ""
    }
    
}
