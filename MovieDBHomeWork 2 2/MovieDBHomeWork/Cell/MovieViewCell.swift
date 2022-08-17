//
//  MovieViewCell.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import UIKit



protocol CellSubclassDelegate: AnyObject {
    func AddFavourite(cell: MovieViewCell)
}

class MovieViewCell: UITableViewCell {
    
    weak var delegate:CellSubclassDelegate?
    
    static let identifier = "MovieViewCell"

    @IBOutlet weak var movieImage: UIImageView!
   // @IBOutlet weak var someButton: UIButton!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    /* @IBAction func someButtonTapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(cell: self)
    }*/
   
    @IBAction func addFav(_ sender: Any) {
        delegate?.AddFavourite(cell: self)
    }
    
    
    func configureCell(title: String?, overview: String?, data: Data?) {
        
        movieTitle.text = title
        movieOverview.text = overview
        
        movieImage.image = nil
        if let imageData = data{
            movieImage.image = UIImage(data: imageData)
           //  movieImage.image = nil
        }
    }
    
}

    

