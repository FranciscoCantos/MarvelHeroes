//
//  CharacterToCharacterDetailViewModelMapper.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

/// Mapper to map a character entity to a view model
class CharacterToCharacterDetailViewModelMapper {
    private let character: Character
    
    init(_ character: Character) {
        self.character = character
    }
    
    func map() -> CharacterDetailViewModel {
        return CharacterDetailViewModel(name: formattedCharacterName(),
                                        imageURL: character.imageUrl,
                                        id: character.id,
                                        detailsUrl: character.getDetailsUrl(),
                                        description: character.characterDescription,
                                        buttons: getButtons())
    }
    
    private func getButtons() -> [AppearanceButtonViewModel] {
        var buttonsArray = [AppearanceButtonViewModel]()
        if character.comics.available > 0 {
            buttonsArray.append(AppearanceButtonViewModel(type: .comics, count: character.comics.available))
        }
        if character.events.available > 0 {
            buttonsArray.append(AppearanceButtonViewModel(type: .events, count: character.events.available))
        }
        if character.series.available > 0 {
            buttonsArray.append(AppearanceButtonViewModel(type: .series, count: character.series.available))
        }
        if character.stories.available > 0 {
            buttonsArray.append(AppearanceButtonViewModel(type: .stories, count: character.stories.available))
        }
        return buttonsArray
    }
        
    private func formattedCharacterName() -> String {
        var result = character.name
        if character.name.contains("(") {
            result = character.name.replacingOccurrences(of: "(", with: "\n(")
        }
        return result
    }
}
