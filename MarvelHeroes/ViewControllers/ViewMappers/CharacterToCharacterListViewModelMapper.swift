//
//  CharacterToCharacterListViewModelMapper.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

/// Mapper to map a character entity to a view model
class CharacterToCharacterListViewModelMapper {
    private let character: Character
    
    init(_ character: Character) {
        self.character = character
    }
    
    func map() -> CharacterListViewModel {
        return CharacterListViewModel(name: formattedCharacterName(), imageURL: character.imageUrl, id: character.id)
    }
    
    private func formattedCharacterName() -> String {
        var result = character.name
        if character.name.contains("(") {
            result = character.name.replacingOccurrences(of: "(", with: "\n(")
        }
        return result
    }
}
