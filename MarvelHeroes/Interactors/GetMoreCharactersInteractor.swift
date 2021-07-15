//
//  GetMoreCharactersInteractor.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

protocol GetMoreCharactersInteractorProtocol {
    func getMoreCharacters(completion: @escaping GetCharactersCompletionBlock)
}


/// Interactor that gets characters making like a pagination
class GetMoreCharactersInteractor: GetMoreCharactersInteractorProtocol {
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    
    ///  Get more characters from the Marvel API using an offset
    /// - Parameter completion: Retrieves the next characters
    func getMoreCharacters(completion: @escaping GetCharactersCompletionBlock) {
        repository.getMoreCharacters() { (response, errorMessage) in
            if let charactersResponse = response?.characters {
                completion(charactersResponse, nil)
            } else {
                completion(nil, errorMessage)
            }
        }
    }
}
