//
//  MovieDeatilsViewController.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 14/02/2022.
//

import UIKit

class MovieDeatilsViewController: UIViewController {
    
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieOverview: UILabel!
    
    
    var titlemovie = ""
    var overview = ""
    var imagemovie :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = titlemovie
        movieOverview.text = overview
        movieImage.image = imagemovie
        
    
        
    }

}
