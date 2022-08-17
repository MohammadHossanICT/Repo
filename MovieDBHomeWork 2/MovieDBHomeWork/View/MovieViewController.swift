//
//  MovieViewController.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 14/02/2022.
//

import UIKit

class  MovieViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var FavouriteTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var presenter: MoviePresenter!
    
    var finalname = ""
    
   var movieTitle = ""
    var movieOverview = ""
    var movieImage : UIImage?
    var favorites = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       userName.text = "Hello: " + finalname
    }
    
    private func setUpUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        FavouriteTableView.delegate = self
        FavouriteTableView.dataSource = self
        searchBar.delegate = self
    }
    
    
    @IBAction func dismish(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        
       if sender.selectedSegmentIndex == 0{
        FavouriteTableView.isHidden = true
        tableView.isHidden = false
        setUpUI()
        presenter = MoviePresenter(view: self)
        presenter.getMovies()
           
       } else {
           FavouriteTableView.isHidden = false
           tableView.isHidden = true
         
       }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterMovies(searchText: searchText)
    }
    
}

extension MovieViewController: MovieViewProtocol {
    
    func resfreshTableView() {
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneButton)
        present(alert, animated: true, completion: nil)
    }
    
}

extension MovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === FavouriteTableView {
            return favorites.count
          } else {
            return presenter.rows
          }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === FavouriteTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier, for: indexPath) as! FavouriteTableViewCell
            let row = indexPath.row
            let title = favorites[row].originalTitle
            let overview = favorites[row].overview
            let baseImageURL = "https://image.tmdb.org/t/p/w500\(favorites[row].posterPath)"
            let data = presenter.getImageData(by: baseImageURL)
            cell.delegate = self
            cell.configureCell(title: title, overview: overview, data: data)
                   cell.delegate = self // This cause favorite protocol method trigered
                   return cell
           } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: MovieViewCell.identifier, for: indexPath) as! MovieViewCell
               let row = indexPath.row
               let title = presenter.getTitle(by: row)
               let overview = presenter.getOverview(by: row)
               let baseImageURL = presenter.getUrlImage(by: row)
               let data = presenter.getImageData(by: baseImageURL)
               let id = presenter.getID(by: row)
               let posterPath = presenter.getPosterPath(by: row)
               cell.delegate = self
               cell.configureCell(title: title, overview: overview, data: data, id: id, posterPath: posterPath, row: row)
               return cell
           }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dc = storyboard?.instantiateViewController(withIdentifier: "MovieDeatilsViewController") as! MovieDeatilsViewController
        
        let row = indexPath.row
        presenter.selectMovie(row: row)
        dc.titlemovie = presenter.getTitle(by: row) ?? ""
        dc.overview = presenter.getOverview(by: row) ?? ""
        let baseImageURL = presenter.getUrlImage(by: row)
        dc.imagemovie = UIImage(data: presenter.getImageData(by: baseImageURL)!)
        dc.movieSelected = presenter.movieSelected
        self.navigationController?.pushViewController(dc, animated: true)
   }
}



extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

extension MovieViewController : CellSubclassDelegate{
    func buttonTapped(cell: MovieViewCell) {
        guard (self.tableView.indexPath(for: cell) != nil) else {return}
            let customViewController = storyboard?.instantiateViewController(withIdentifier: "MovieDeatilsViewController") as? MovieDeatilsViewController
        customViewController?.titlemovie = cell.movieTitle.text ?? ""
        customViewController?.imagemovie = cell.movieImage.image
        customViewController?.overview = cell.movieOverview.text ?? ""
        let rowSelected = cell.row
        presenter.selectMovie(row: rowSelected)
        customViewController?.movieSelected = presenter.movieSelected
        self.navigationController?.pushViewController(customViewController!, animated: true)
                    
                   
    }
    
    func AddFavourite(cell: MovieViewCell) {
        
        let movieId = cell.id
        movieTitle = cell.movieTitle.text ?? ""
        movieOverview = cell.movieOverview.text ?? ""
        movieImage =  cell.movieImage.image
        let posterPath = cell.posterPath
        // you need to search in core data this move
        let movie = Movie(id: movieId, originalTitle: movieTitle, overview: movieOverview, posterPath: posterPath)
        favorites.append(movie)
        FavouriteTableView.reloadData()
    }
}
extension MovieViewController :  CellDelegate{
    func AddFavourite(cell: FavouriteTableViewCell) {
        guard (self.tableView.indexPath(for: cell) != nil) else {return}
        
        movieTitle = cell.FavouritemovieTitle.text ?? ""
        movieOverview = cell.FavouritemovieOverview.text ?? ""
        movieImage =  cell.FavouriteImage.image
    }
    
    
    
}





