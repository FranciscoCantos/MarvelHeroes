//
//  CharactersPresenter.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit

protocol CharactersPresenterProtocol {
    func getCharacters()
    func searchCharacters(name: String)
    func navigateToCharacterDetail(character: CharacterListViewModel)
}

/// Presenter that manages the characters list to be showed
class CharactersPresenter: CharactersPresenterProtocol {
    private let getCharactersInteractor: GetCharactersInteractorProtocol
    private let searchCharacterInteractor: SearchCharacterInteractorProtocol
    
    private let router: MainRouterProtocol
    var charactersArray: [Character] = []
    
    weak var view: CharactersViewControllerProtocol?
    
    init(router: MainRouterProtocol,
         getCharactersInteractor: GetCharactersInteractorProtocol,
         searchCharacterInteractor: SearchCharacterInteractorProtocol) {
        self.getCharactersInteractor = getCharactersInteractor
        self.searchCharacterInteractor = searchCharacterInteractor
        self.router = router
    }
    
    /// Method that calls interactor to get the character list
    func getCharacters() {
        view?.startLoading()
        getCharactersInteractor.getCharacters { [weak self] (retrievedCharacters, errorMessage) in
            self?.view?.stopLoading()
            self?.manageCharactersResponse(retrievedCharacters, errorMessage)
        }
    }
    
    /// Method that manage the response of the interactor
    /// - Parameters:
    ///   - retrievedCharacters: Characters retrieved from network
    ///   - errorMessage: Error message to show if needed
    func manageCharactersResponse(_ retrievedCharacters: [Character]?,_ errorMessage: String?) {
        if let charactersRetrieved = retrievedCharacters {
            charactersArray.append(contentsOf: charactersRetrieved)
            view?.showCharacters(buildCharacterViewModels(charactersRetrieved))
        } else {
            view?.showError(errorMessage)
        }
    }
    
    /// Method that maps the Character entities to view models to show in the view
    /// - Parameter charactersArray: The array of Characters to map
    /// - Returns: Array of view models
    func buildCharacterViewModels(_ charactersArray: [Character]) -> [CharacterListViewModel] {
        let charactersViewModels = charactersArray.compactMap {
            CharacterToCharacterListViewModelMapper($0).map()
        }
        return charactersViewModels
    }
        
    /// Method that calls search interactor to get the character with the same name
    /// - Parameter name: Name of the character to search
    func searchCharacters(name: String) {
        view?.startLoading()
        searchCharacterInteractor.searchCharacter(name: name) { [weak self] (retrievedCharacter, errorMessage) in
            self?.view?.stopLoading()
            self?.manageSearchCharactersResponse(retrievedCharacter, errorMessage)
        }
    }
    
    /// Method that manage the response of the interactor
    /// - Parameters:
    ///   - retrievedCharacters: Characters retrieved from network search
    ///   - errorMessage: Error message to show if needed
    func manageSearchCharactersResponse(_ retrievedCharacters: [Character]?,_ errorMessage: String?) {
        if let charactersRetrieved = retrievedCharacters {
            view?.showSearchedCharacters(buildCharacterViewModels(charactersRetrieved))
        } else {
            view?.showError(errorMessage)
        }
    }
    
    /// Navigation method to show a view with details of the given character.
    /// - Parameter character: The id of the character to show details
    func navigateToCharacterDetail(character: CharacterListViewModel) {
        router.navigateToCharacterDetail(character.id)
    }
}
