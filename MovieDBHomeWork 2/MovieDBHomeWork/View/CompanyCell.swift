//
//  CompanyCell.swift
//  MovieDBHomeWork
//
//  Created by Christian Quicano on 2/25/22.
//

import UIKit

class CompanyCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImageView: UIImageView!
    static let identifier = "CompanyCell"
    
    func configureCell(data: Data) {
        let image = UIImage(data: data)
        companyImageView.image = image
    }
}
