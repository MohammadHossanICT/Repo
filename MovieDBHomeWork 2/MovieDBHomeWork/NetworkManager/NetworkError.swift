//
//  NetworkError.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation
enum NetworkError: Error, LocalizedError {
    case badURL
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "This is a bad URL"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
}
