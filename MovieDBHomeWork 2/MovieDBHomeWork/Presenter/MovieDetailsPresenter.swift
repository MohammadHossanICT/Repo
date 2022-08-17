//
//  MovieDetailsPresenter.swift
//  MovieDBHomeWork
//
//  Created by Christian Quicano on 2/25/22.
//

import Foundation

class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    
    let view: MovieDetailsViewProtocol
    let movieSelected: Movie
    var arrayCompanies = [Company]()
    var arrayImageData = [Data]()
    private let networkManager = NetworkManager()
    
    init(view: MovieDetailsViewProtocol, movieSelected: Movie) {
        self.view = view
        self.movieSelected = movieSelected
    }
    
    func getMovieDetails() {
        
        let id = movieSelected.id
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=6622998c4ceac172a976a1136b204df4"
        
        networkManager
            .getMovie(from: url) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.arrayCompanies = response.productionCompanies ?? []
                    self?.getDownloadImages()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getDownloadImages() {
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        let companiesfiltered = arrayCompanies.filter { !($0.logoPath?.isEmpty ?? true) }
        let urls = companiesfiltered.map { "\(baseImageURL)\($0.logoPath ?? "")" }
        
        let group = DispatchGroup()
        for url in urls {
            group.enter()
            networkManager.getData(from: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.arrayImageData.append(data)
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.view.refreshCollectionView()
        }
    }
}
