//
//  CDMovie+Utils.swift
//  ChallengeMovieDB
//
//  Created by Christian Quicano on 2/22/22.
//

import Foundation

extension CDMovie {
    
    func createMovie() -> Movie {
        
        let id = Int(self.movieid)
        let posterPath = self.posterPath ?? ""
        let originalTitle = self.originalTitle ?? ""
        let overview = self.overview ?? ""
//        let releaseDate = self.releaseDate ?? ""
//        let isFav = self.isFav
        
        return Movie(id: id, originalTitle: originalTitle, overview: overview, posterPath: posterPath)
        
//        return Movie(self)
    }
    
}
