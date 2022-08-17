//
//  MovieDeatilsViewController.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 14/02/2022.
//

import UIKit

class MovieDeatilsViewController: UIViewController {
    
    private var presenter: MovieDetailsPresenter!
    var movieSelected: Movie?
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titlemovie = ""
    var overview = ""
    var imagemovie :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = titlemovie
        movieOverview.text = overview
        movieImage.image = imagemovie
        
        collectionView.dataSource = self
        
        if let movieSelected = movieSelected {
            presenter = MovieDetailsPresenter(view: self, movieSelected: movieSelected)
            presenter.getMovieDetails()
        }
        
    }

}

extension MovieDeatilsViewController: MovieDetailsViewProtocol {
    func refreshCollectionView() {
        collectionView.reloadData()
    }
}

extension MovieDeatilsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.arrayImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCell.identifier, for: indexPath) as! CompanyCell
        cell.configureCell(data: presenter.arrayImageData[indexPath.row])
        return cell
    }
    
}
