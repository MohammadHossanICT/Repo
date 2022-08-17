//
//  MovieViewCell.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 12/02/2022.
//

import UIKit



protocol CellSubclassDelegate: AnyObject {
    func buttonTapped(cell: MovieViewCell)
    func AddFavourite(cell: MovieViewCell)
}

class MovieViewCell: UITableViewCell {
    
    weak var delegate:CellSubclassDelegate?
    
    static let identifier = "MovieViewCell"
    
    weak var delegate1:CellDelegate?

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var someButton: UIButton!
    
    @IBOutlet weak var addFav: UIButton!
    var id = 0
    var posterPath = ""
    var row = 0
    
    @IBAction func someButtonTapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(cell: self)
    }
   
    @IBAction func addFav(_ sender: Any) {
        delegate?.AddFavourite(cell: self)
        self.addFav.isHidden = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    func configureCell(title: String?, overview: String?, data: Data?, id: Int, posterPath: String, row: Int) {
        
        movieTitle.text = title
        movieOverview.text = overview
        self.id = id
        self.posterPath = posterPath
        self.row = row
        
        movieImage.image = nil
        if let imageData = data{
            movieImage.image = UIImage(data: imageData)
           //  movieImage.image = nil
        }
    }
    
}

    

