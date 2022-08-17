//
//  MovieProtocols.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation
protocol MoviePresenterProtocol {
    func getMovies()
    func getTitle(by row: Int) -> String?
    func getOverview(by row: Int) -> String?
    
  //  func getImageData(by row: Int) -> UIImage?
    func getImageData(by key: String) -> Data?
    var rows: Int { get }
}

protocol MovieViewProtocol {
    func resfreshTableView()
    func displayError(_ message: String)
}


protocol MovieDetailsPresenterProtocol {
    func getMovieDetails()
}

protocol MovieDetailsViewProtocol {
    func refreshCollectionView()
}
