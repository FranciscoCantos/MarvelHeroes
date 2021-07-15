//
//  CharacterDetailViewModel.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit

/// View model of the details of a character
struct CharacterDetailViewModel {
    let name: String
    let imageURL: String
    let id: Int
    let detailsUrl: URL?
    let description: String
    let buttons: [AppearanceButtonViewModel]

}
