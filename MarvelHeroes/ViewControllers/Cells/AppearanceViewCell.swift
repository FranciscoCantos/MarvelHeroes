//
//  AppearanceViewCell.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit


/// Cell used to show all the appearances of a character
class AppearanceViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    class var identifier: String { return "AppearanceViewCell" }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, description: String, imageURL: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
    
        titleLabel.font = UIFont(name: comicsFontName, size: 20)
        titleLabel.text = title
        titleLabel.tintColor = .white
        
        descriptionLabel.text = description
        descriptionLabel.tintColor = .white
        
        imageView.setNetworkImage(urlString: imageURL)
    }
}
