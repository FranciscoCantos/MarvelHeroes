//
//  CharactersTableViewCell.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import UIKit

// Cell used to show all the characters on a list
class CharactersTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Configure the cell to show the model information.
    func configureCell(_ characterViewModel: CharacterListViewModel) {
        backgroundColor = .clear
        selectionStyle = .none
        
        nameLabel.text = characterViewModel.name
        nameLabel.font = UIFont(name: comicsFontName, size: 24.0)
        nameLabel.textColor = .white
        
        photoView.setNetworkImage(urlString: characterViewModel.imageURL)
    }
}

