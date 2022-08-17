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
     //  setUpUI()
      // presenter = MoviePresenter(view: self)
      // searchBarText()
      //  tableView.isHidden  = false
       // FavouriteTableView.isHidden = true
       
    }
    private func setUpUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        FavouriteTableView.delegate = self
        FavouriteTableView.dataSource = self
    }
    
    
    @IBAction func dismish(_ sender: Any) {
        self.dismiss(animated: true)
    }
    private func searchBarText() {
        searchBar.delegate = self
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
        if searchText == ""{
            presenter.getMovies()
        }
        else {
            
            
            presenter.movies = presenter.movies.filter({ movies in
                    let originalTitle = movies.originalTitle.lowercased().range(of: searchText.lowercased())
                    let overview = movies.overview.lowercased().range(of: searchText.lowercased())
                    let posterPath = movies.posterPath.lowercased().range(of: searchText.lowercased())
                return (originalTitle != nil) == true || (overview != nil) == true || (posterPath != nil) == true}
                )
        }
        
        tableView.reloadData()
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
                   //cell.delegate = self // This cause favorite protocol method trigered
            
            let row = indexPath.row
            let title = presenter.getTitle(by: row)
            let overview = presenter.getOverview(by: row)
            let baseImageURL = presenter.getUrlImage(by: row)
            let data = presenter.getImageData(by: baseImageURL)
            cell.delegate = self
            cell.configureCell(title: title, overview: overview, data: data)
            return cell
    
           } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: MovieViewCell.identifier, for: indexPath) as! MovieViewCell
               let row = indexPath.row
               let title = presenter.getTitle(by: row)
               let overview = presenter.getOverview(by: row)
               let baseImageURL = presenter.getUrlImage(by: row)
               let data = presenter.getImageData(by: baseImageURL)
               cell.delegate = self
               cell.configureCell(title: title, overview: overview, data: data)
               return cell
           }
        
        /*
       let cell = tableView.dequeueReusableCell(withIdentifier: MovieViewCell.identifier, for: indexPath) as! MovieViewCell
        
        let row = indexPath.row
        let title = presenter.getTitle(by: row)
        let overview = presenter.getOverview(by: row)
        let baseImageURL = presenter.getUrlImage(by: row)
        let data = presenter.getImageData(by: baseImageURL)
        cell.delegate = self
        cell.configureCell(title: title, overview: overview, data: data)
        return cell
         */
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dc = storyboard?.instantiateViewController(withIdentifier: "MovieDeatilsViewController") as! MovieDeatilsViewController
        
        let row = indexPath.row
       dc.titlemovie = presenter.getTitle(by: row) ?? ""
       dc.overview = presenter.getOverview(by: row) ?? ""
       let baseImageURL = presenter.getUrlImage(by: row)
       dc.imagemovie = UIImage(data: presenter.getImageData(by: baseImageURL)!)
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
        self.navigationController?.pushViewController(customViewController!, animated: true)
                    
                   
    }
    
    func AddFavourite(cell: MovieViewCell) {
        movieTitle = cell.movieTitle.text ?? ""
        movieOverview = cell.movieOverview.text ?? ""
//        movieImage =  cell.movieImage.image
        // you need to search in core data this move
        let movie = Movie(originalTitle: movieTitle, overview: movieOverview, posterPath: "")
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





