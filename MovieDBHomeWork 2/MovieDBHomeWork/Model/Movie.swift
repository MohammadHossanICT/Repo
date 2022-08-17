//
//  Movie.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let originalTitle: String
    let overview: String
    let posterPath: String
    let productionCompanies: [Company]?
    
    
    enum CodingKeys: String, CodingKey {
        case  overview, id
        case originalTitle = "original_title"
        case posterPath = "poster_path"
       case productionCompanies = "production_companies"
    }
    
    init(id : Int, originalTitle: String, overview: String, posterPath: String) {
        self.id = id
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.productionCompanies = nil
    }
    
  
   init(_ cdMovie : CDMovie){
       id = Int(cdMovie.movieid)
       originalTitle = cdMovie.originalTitle ?? ""
        overview = cdMovie.overview ?? ""
        posterPath = cdMovie.posterPath ?? ""
       productionCompanies = nil
    }
    
}
