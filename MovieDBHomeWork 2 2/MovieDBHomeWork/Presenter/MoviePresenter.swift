//
//  MoviePresenter.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import Foundation
import CoreData

class MoviePresenter: MoviePresenterProtocol {
    
    
    private let view: MovieViewProtocol
    private let networkManager: NetworkManager
    var movies = [Movie]()
    private var cache = [String: Data]()
    private var after: String {
        userdefaults.string(forKey: keyAfter) ?? ""
    }
    private let userdefaults = UserDefaults.standard
    private let keyAfter = "keyAfter"
    
    var rows: Int {
        return movies.count
    }
    
    init(view: MovieViewProtocol, networkManager: NetworkManager = NetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }
    
    
    func getMovies() {
        
        let temp = getAllMovies()
        
        if temp.isEmpty {
            
            let url = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=3&api_key=6622998c4ceac172a976a1136b204df4"
            
            networkManager.getMovies(from: url) { [weak self] result in
                switch result {
                case .success(let response):
                   let movieTemp = response.results
                    self?.saveMovie(movieTemp)
                    //self?.movies = response.results
                    self?.downloadImages()
                    DispatchQueue.main.async {
                        self?.view.resfreshTableView()
                    }
                case .failure(let error):
                    
                    DispatchQueue.main.async {
                        self?.view.displayError(error.localizedDescription)
                    }
                }
            }
            
        } else {
            
            movies = temp
            DispatchQueue.main.async { [weak self] in
                self?.view.resfreshTableView()
            }
            downloadImages()
            
        }
        
        
    }
    
    
    private func saveMovie(_ movies: [Movie]){
        
        let context  = CoreDataManager.shared.mainContext
        
        guard let description  = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)
        else {return}
        
        for movie in movies {
            let cdMovie = CDMovie(entity: description, insertInto: context)
            
            cdMovie.originalTitle  = movie.originalTitle
            cdMovie.overview = movie.overview
            cdMovie.posterPath  = movie.posterPath
        }
        CoreDataManager.shared.saveContext()
    }
    
    private func getAllMovies() -> [Movie]
    {
        let request : NSFetchRequest = CDMovie.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        do {
            let allMovies = try context.fetch(request)
            
            var movies  = [Movie]()
            for movie in allMovies {
                let tem = Movie(movie)
                movies.append(tem)
                
            }
            return movies
            // return allStories.map { Story($0) }
            
            
        } catch  {
            print(error)
        }
       return []
        
        
        
    }
    func getTitle(by row: Int) -> String? {
        return movies[row].originalTitle
    }
    
    func getOverview(by row: Int) -> String? {
        return movies[row].overview
    }
    
    func getImageData(by key: String) -> Data? {
        return cache[key]
    }
    
    func getUrlImage(by row: Int) -> String {
        let baseImageURL = "https://image.tmdb.org/t/p/w500\(movies[row].posterPath)"
        return baseImageURL
    }
   
    
    private func downloadImages() {
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        let posterArray = movies.map { "\(baseImageURL)\($0.posterPath)" }
        
        let group = DispatchGroup()
        group.enter()
        for (index, url) in posterArray.enumerated() {
            networkManager.getImageData(from: url) { [weak self] data in
                if let data = data {
                    self?.cache[url] = data
                }
            }
        }
        group.leave()
        group.notify(queue: .main) { [weak self] in
            self?.view.resfreshTableView()
        }
    }
    
    
}
