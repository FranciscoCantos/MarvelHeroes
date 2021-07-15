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
    private let characterId: Int
    private var character : Character?
    
    weak var view: CharacterDetailViewController?

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
            if let character = retrievedCharacter {
                self?.character = character
                let viewModel = CharacterToCharacterDetailViewModelMapper(character).map()
                self?.view?.showCharacter(viewModel)
            } else {
                self?.view?.showError(errorMessage ?? "Unknown error description")
            }
        }
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
        UIApplication.shared.open(detailsUrl)
    }
}
