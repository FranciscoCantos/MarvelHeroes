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
    func getMoreCharacters()
    func searchCharacters(name: String)
    func navigateToCharacterDetail(character: CharacterListViewModel)
}

/// Presenter that manages the characters list to be showed
class CharactersPresenter: CharactersPresenterProtocol {
    
    private let getCharactersInteractor: GetCharactersInteractorProtocol
    private let getMoreCharactersInteractor: GetMoreCharactersInteractorProtocol
    private let searchCharacterInteractor: SearchCharacterInteractorProtocol
    
    private let router: MainRouterProtocol
    private var charactersArray: [Character] = []
    
    weak var view: CharactersViewControllerProtocol?
    
    init(router: MainRouterProtocol,
         getCharactersInteractor: GetCharactersInteractorProtocol,
         getMoreCharactersInteractor: GetMoreCharactersInteractorProtocol,
         searchCharacterInteractor: SearchCharacterInteractorProtocol) {
        
        self.getCharactersInteractor = getCharactersInteractor
        self.getMoreCharactersInteractor = getMoreCharactersInteractor
        self.searchCharacterInteractor = searchCharacterInteractor
        
        self.router = router
    }
    
    
    /// Method that calls interactor to get the character list
    func getCharacters() {
        view?.startLoading()
        getCharactersInteractor.getCharacters { [weak self] (retrievedCharacters, errorMessage) in
            self?.view?.stopLoading()
            if let characters = retrievedCharacters {
                self?.charactersArray = characters
                let charactersViewModels = characters.compactMap {
                    CharacterToCharacterListViewModelMapper($0).map()
                }
                self?.view?.showCharacters(charactersViewModels)
            } else {
                self?.view?.showError(errorMessage ?? "Unknown error description")
            }
        }

    }
    
    /// Method that calls interactor to get the more characters handling a pagination
    func getMoreCharacters() {
        view?.startLoading()
        getMoreCharactersInteractor.getMoreCharacters { [weak self] (retrievedCharacters, errorMessage) in
            self?.view?.stopLoading()
            if let newCharacters = retrievedCharacters {
                self?.charactersArray.append(contentsOf: newCharacters)
                let charactersViewModels = newCharacters.compactMap {
                    CharacterToCharacterListViewModelMapper($0).map()
                }
                self?.view?.appendMoreCharacters(charactersViewModels)
            } else {
                self?.view?.showError(errorMessage ?? "Unknown error description")
            }
        }
    }
    
    
    /// Method that calls search interactor to get the character with the same name
    /// - Parameter name: Name of the character to search
    func searchCharacters(name: String) {
        view?.startLoading()
        searchCharacterInteractor.searchCharacter(name: name) { [weak self] (retrievedCharacter, errorMessage) in
            self?.view?.stopLoading()
            if let newCharacter = retrievedCharacter {
                let characterViewModel = newCharacter.compactMap {
                    CharacterToCharacterListViewModelMapper($0).map()
                }
                self?.view?.showSearchedCharacters(characterViewModel)
            } else {
                self?.view?.showError(errorMessage ?? "Unknown error description")
            }
        }
    }
    
    /// Navigation method to show a view with details of the given character.
    /// - Parameter character: The id of the character to show details
    func navigateToCharacterDetail(character: CharacterListViewModel) {
        router.navigateToCharacterDetail(character.id)
    }
}
