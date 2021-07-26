//
//  CharacterDetailPresenter.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit

protocol CharacterDetailPresenterProtocol {
    func showCharacterDetail()
    func navigateToDetailInfo()
    func navigateToAppearances(characterId: Int, appearanceType: AppearanceType)
}

/// Presenter that manages the character info to be showed
class CharacterDetailPresenter: CharacterDetailPresenterProtocol {
    private let getCharacterInfoInteractor: GetCharacterInfoInteractorProtocol

    private let router: MainRouterProtocol
    let characterId: Int
    var character: Character?
    
    weak var view: CharacterDetailViewControllerProtocol?

    init(router: MainRouterProtocol,
         getCharacterInfoInteractor: GetCharacterInfoInteractorProtocol,
         characterId: Int) {
        self.getCharacterInfoInteractor = getCharacterInfoInteractor
        self.router = router
        self.characterId = characterId
    }
    
    /// Method that calls interactor to get the character info
    func showCharacterDetail() {
        view?.startLoading()
        getCharacterInfoInteractor.getCharacterInfo(characterId: characterId) { [weak self] (retrievedCharacter, errorMessage) in
            self?.view?.stopLoading()
            self?.manageGetCharacterInfoResponse(retrievedCharacter, errorMessage)
        }
    }
    
    /// Method that manage the response of the interactor
    /// - Parameters:
    ///   - retrievedCharacter: Character info retrieved from network
    ///   - errorMessage: Error message to show if needed
    func manageGetCharacterInfoResponse(_ retrievedCharacter: Character?, _ errorMessage: String?) {
        if let character = retrievedCharacter {
            self.character = character
            view?.showCharacter(buildCharacterDetailViewModel(character))
        } else {
            view?.showError(errorMessage)
        }
    }
    
    /// Method that maps the Characte entities to detail view model to show in the view
    /// - Parameter character: Character to map
    /// - Returns: View model
    func buildCharacterDetailViewModel(_ character: Character) -> CharacterDetailViewModel {
        return CharacterToCharacterDetailViewModelMapper(character).map()
    }
    
    /// Navigation method to show a view with the selected appeances types
    /// - Parameters:
    ///   - characterId: Id of the character
    ///   - appearanceType: Type of the appearances to show
    func navigateToAppearances(characterId: Int, appearanceType: AppearanceType) {
        router.navigateToAppearances(characterId: characterId, appearanceType: appearanceType)
    }
    
    /// Navigation method to show a web from de Marvel website to show more details of the character.
    func navigateToDetailInfo() {
        guard let detailsUrl = character?.getDetailsUrl() else { return }
        router.navigateToURL(detailsUrl)
    }
}
