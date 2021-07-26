//
//  MainRouter.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit

protocol MainRouterProtocol {
    func navigateToCharacterDetail(_ characterId: Int)
    func navigateToAppearances(characterId: Int, appearanceType: AppearanceType)
    func navigateToURL(_ url: URL)
}

/// Router to manage all the navigations of the app
class MainRouter: MainRouterProtocol, TopViewControllerGettableProtocol {
    
    private var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
        showInitialNavigation()
    }
    
    /// Method that returns the root view controller used as the first view
    /// - Returns: The first view of the app
    func getRootViewController() -> UIViewController? {
        return rootViewController
    }
    
    /// Private method that initializes the navigation setting the first view controller
    private func showInitialNavigation() {
        showCharacters()
    }
    
    /// Method that navigate to show a list of characters
    private func showCharacters() {
        let getCharactersInteractor = GetCharactersInteractor(repository: CharactersRepository())
        let searchCharactersInteractor = SearchCharacterInteractor(repository: CharactersRepository())
        let charactersPresenter = CharactersPresenter(router: self,
                                                      getCharactersInteractor: getCharactersInteractor,
                                                      searchCharacterInteractor: searchCharactersInteractor)
        let charactersViewController = CharactersViewController(charactersPresenter: charactersPresenter)
        charactersPresenter.view = charactersViewController
        
        rootViewController = UINavigationController(rootViewController: charactersViewController)
    }
    
    
    /// Method that navigates to show a view with the details of a character
    /// - Parameters:
    ///   - characterId: The ID of the character to show
    ///   - originVC: Origin view controller of the navigation
    func navigateToCharacterDetail(_ characterId: Int) {
        let getCharacterInfoInteractor = GetCharacterInfoInteractor(repository: CharactersRepository())
        let characterDetailPresenter = CharacterDetailPresenter(router: self,
                                                                getCharacterInfoInteractor: getCharacterInfoInteractor,
                                                                characterId: characterId)
        let characterDetailViewController = CharacterDetailViewController(characterDetailPresenter: characterDetailPresenter)
        characterDetailPresenter.view = characterDetailViewController
        
        topNavController?.pushViewController(characterDetailViewController, animated: true)
    }
    
    /// Method that navigates to show a view with the appearances of a character
    /// - Parameters:
    ///   - characterId: The ID of the character to show
    ///   - appearanceType: The appearances type to show
    ///   - originVC: Origin view controller of the navigation
    func navigateToAppearances(characterId: Int, appearanceType: AppearanceType) {
        let getAppearancesInteractor = GetAppearancesInteractor(repository: AppearancesRepository())
        let appearancesPresenter = AppearancesPresenter(router: self,
                                                        getAppearancesInteractor: getAppearancesInteractor)
        let appearancesViewController = AppearancesViewController(appearancesPresenter: appearancesPresenter,
                                                                  characterId: characterId,
                                                                  appearanceType: appearanceType)
        appearancesPresenter.view = appearancesViewController
        topNavController?.present(appearancesViewController, animated: true)
    }
    
    /// Method that navigates to a given url
    /// - Parameter url: URL needed to navigate
    func navigateToURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
