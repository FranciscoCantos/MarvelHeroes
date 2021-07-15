//
//  AppearanceButtonViewModel.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos

import Foundation
import UIKit

/// The differant appearances types
enum AppearanceType {
    case comics, series, stories, events
}

/// View model for the appearance button
struct AppearanceButtonViewModel {
    let type: AppearanceType
    let count: Int
    
    func getResources() -> (title: String, icon: UIImage?) {
        switch type {
        case .comics:
            return (title: "Comics: \(count)", icon: UIImage(named: "ComicIcon"))
        case .series:
            return (title: "Series: \(count)", icon: UIImage(named: "MovieIcon"))
        case .stories:
            return (title: "Stories: \(count)", icon: UIImage(named: "StoryIcon"))
        case .events:
            return (title: "Events: \(count)", icon: UIImage(named: "EventIcon"))
        }
    }
}
