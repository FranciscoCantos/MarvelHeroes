//
//  SearchCharacterInteractor.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

protocol SearchCharacterInteractorProtocol {
    func searchCharacter(name: String, completion: @escaping GetCharactersCompletionBlock)
}


/// Interactor that gets characters by a full name given.
class SearchCharacterInteractor: SearchCharacterInteractorProtocol {
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    ///  Search a character by name on the Marvel API
    /// - Parameters:
    ///   - name: Name of the character to search
    ///   - completion: Retrieves characters with the same name
    func searchCharacter(name: String, completion: @escaping GetCharactersCompletionBlock) {
        repository.searchCharacter(name: name){ (response, errorMessage) in
            if let charactersResponse = response?.characters {
                completion(charactersResponse, nil)
            } else {
                completion(nil, errorMessage)
            }
        }
    }
}
