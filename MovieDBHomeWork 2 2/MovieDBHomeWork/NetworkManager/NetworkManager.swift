//
//  NetworkManager.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation

import Foundation

class NetworkManager {
    
    func getMovies(from url: String, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void ) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(.other(error)))
                return
            }

            if let data = data {
                //decode
                do {
                    let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(.other(error)))
                }
            }
        }
        .resume()
    }
    
    func getImageData(from url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data)
        }
        .resume()
    }
    
}
