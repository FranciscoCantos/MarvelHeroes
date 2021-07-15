//
//  GetCharacterInfoInteractor.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

typealias GetCharacterInfoCompletionBlock = (_ character: Character?, _ errorMessage: String?) -> Void

protocol GetCharacterInfoInteractorProtocol {
    func getCharacterInfo(characterId: Int, completion: @escaping GetCharacterInfoCompletionBlock)
}


/// Interactor that gets the general info of a given character
class GetCharacterInfoInteractor: GetCharacterInfoInteractorProtocol {
    
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    
    ///  Get the full info of a character
    /// - Parameters:
    ///   - characterId: Id of the character to retrieve info
    ///   - completion: Retrieves the character info
    func getCharacterInfo(characterId: Int, completion: @escaping GetCharacterInfoCompletionBlock) {
        repository.getCharacterInfo(characterId: characterId) { (response, errorMessage) in
            if let characterResponse = response {
                completion(characterResponse.characters.first, nil)
            } else {
                completion(nil, errorMessage)
            }
        }
    }
}
