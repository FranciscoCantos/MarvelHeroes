//
//  AppearanceToAppearancesViewModelMapper.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

/// Mapper to map a appearance entity to a view model
class AppearanceToAppearancesViewModelMapper {
    private let appearance: Appearance
    
    init(_ appearance: Appearance) {
        self.appearance = appearance
    }
    
    func map() -> AppearancesViewModel {
        return AppearancesViewModel(id: appearance.id,
                                    title: formattedAppearanceTitle(),
                                    description: appearance.getAppearanceDescription(),
                                    imageURL: appearance.getImageUrl(),
                                    link: appearance.urls?.first?.url)
    }
    
    private func formattedAppearanceTitle() -> String {
        var result = appearance.title
        if (appearance.title.contains("(")) {
            result = appearance.title.replacingOccurrences(of: "(", with: "\n(").replacingOccurrences(of: ": ", with: ":\n")
        }
        return result
    }
}
