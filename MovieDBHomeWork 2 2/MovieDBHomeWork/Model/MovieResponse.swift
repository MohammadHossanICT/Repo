//
//  MovieResponse.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation
struct MovieResponse: Decodable {
    let page : Int
    let results: [Movie]
}
