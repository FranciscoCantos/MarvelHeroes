//
//  Constants.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit


/// Image used while retrieving an image from Marvel API or when its not found. The same as API uses.
let notFoundImage = UIImage(named: "ImageNotFound")


/// Common font name of the app
let comicsFontName = "Houston Comics Personal Use"

/// Common gif name for the loading views
let marvelGifName = "MarvelGif"

/// Gradient struct with the colors used for the background view of the app
struct gradient {
    public static let topColor = UIColor(hex: "#c81820").cgColor
    public static let bottomColor = UIColor(hex: "#4b090c").cgColor
}

