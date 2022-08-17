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
   
    private(set) var movieSelected: Movie?
    private(set) var companyImages = [Data]()
    private var arrayCompanies: [Company]?
    
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
    func filterMovies(searchText: String) {
        
        if searchText.isEmpty {
            movies = getAllMovies()
            DispatchQueue.main.async { [weak self] in
                self?.view.resfreshTableView()
            }
            return
        }
        
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let predicateTitle = NSPredicate(format: "originalTitle CONTAINS[c] %@", searchText)
//        let predicateOverview = NSPredicate(format: "overview CONTAINS[c] %@", searchText)
//        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateOverview])
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle])
        request.predicate = predicate
        
        let context = CoreDataManager.shared.mainContext
        
        context.performAndWait { [weak self] in
            if let cdMovies = try? context.fetch(request) {
                let moviesFiltered = cdMovies.map { $0.createMovie() }
                self?.movies = moviesFiltered
                DispatchQueue.main.async {
                    self?.view.resfreshTableView()
                }
            }
        }
    }
    
    func selectMovie(row: Int) {
        let movie = movies[row]
        movieSelected = movie
    }
    
    func downloadCompaniesImages() {
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        let array = movieSelected?.productionCompanies ?? []
        let pathArray = array.map { company -> String in
            var completeURL = baseImageURL
            let path = company.logoPath ?? ""
            completeURL.append(path)
            return completeURL
        }
        
        let group = DispatchGroup()
        var temp = [Data]()
        group.enter()
        for (url) in pathArray {
            networkManager.getData(from: url) { result in
                switch result {
                case .success(let data):
                    temp.append(data)
                case .failure(let error):
                    print(error)
                }
            }
        }
        group.leave()
        group.notify(queue: .main) { [weak self] in
            self?.companyImages = temp
        }
    }
    
    
    private func saveMovie(_ movies: [Movie]){
        let context  = CoreDataManager.shared.mainContext
        
        guard let description  = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)
        else {return}
        
        for movie in movies {
            let cdMovie = CDMovie(entity: description, insertInto: context)
            cdMovie.movieid = Int64(movie.id)
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
    
    func getID(by row: Int) -> Int {
        return movies[row].id
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
    
    func getPosterPath(by row: Int) -> String {
        return movies[row].posterPath
    }
    
    private func downloadImages() {
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        let posterArray = movies.map { "\(baseImageURL)\($0.posterPath)" }
        
        let group = DispatchGroup()
        for (index, url) in posterArray.enumerated() {
            group.enter()
            networkManager.getImageData(from: url) { [weak self] data in
                if let data = data {
                    self?.cache[url] = data
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.view.resfreshTableView()
        }
    }
    
    
}
