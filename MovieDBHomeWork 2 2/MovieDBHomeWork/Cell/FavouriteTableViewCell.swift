//
//  FavouriteTableViewCell.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 20/02/2022.
//

import UIKit


protocol CellDelegate: AnyObject {
    func AddFavourite(cell: FavouriteTableViewCell)
}

class FavouriteTableViewCell: UITableViewCell {
    
    weak var delegate:CellDelegate?
    static let identifier = "FavouriteTableViewCell"

    @IBOutlet weak var FavouriteImage: UIImageView!
    @IBOutlet weak var FavouritemovieTitle: UILabel!
    @IBOutlet weak var FavouritemovieOverview: UILabel!
    
    @IBAction func NewMovie(_ sender: UIButton) {
        self.delegate?.AddFavourite(cell: self)
    }
    
    func configureCell(title: String?, overview: String?, data: Data?) {
        
        FavouritemovieTitle.text = title
        FavouritemovieOverview.text = overview
        
        FavouriteImage.image = nil
        if let imageData = data{
            FavouriteImage.image = UIImage(data: imageData)
           //  movieImage.image = nil
        }
    }
    
}
