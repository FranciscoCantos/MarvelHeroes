//
//  GetCharactersInteractor.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//


import Foundation

typealias GetCharactersCompletionBlock = (_ characters: [Character]?, _ errorMessage: String?) -> Void

protocol GetCharactersInteractorProtocol {
    func getCharacters(completion: @escaping GetCharactersCompletionBlock)
}

/// Interactor that get a first amounts of characters
class GetCharactersInteractor: GetCharactersInteractorProtocol {
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    ///  Get characters from the Marvel API
    /// - Parameter completion: Retrieves characters
    func getCharacters(completion: @escaping GetCharactersCompletionBlock) {
        repository.getCharacters() { (response, errorMessage) in
            if let charactersResponse = response?.characters {
                completion(charactersResponse, nil)
            } else {
                completion(nil, errorMessage)
            }
        }
    }
}
