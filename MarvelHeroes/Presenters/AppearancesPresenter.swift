//
//  AppearancesPresenter.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit

protocol AppearancesPresenterProtocol {
    func getAppearances(characterId: Int, appearanceType: AppearanceType)
    func navigateToAppearanceDetail(_ appearanceId : Int)
}

/// Presenter that manages the appearances gallery of a certain type to be showed
class AppearancesPresenter: AppearancesPresenterProtocol {
    
    private let getAppearancesInteractor: GetAppearancesInteractorProtocol

    private let router: MainRouterProtocol
    var appearancesArray: [Appearance] = []
    
    weak var view: AppearancesViewControllerProtocol?
    
    init(router: MainRouterProtocol,
         getAppearancesInteractor: GetAppearancesInteractorProtocol) {
        
        self.getAppearancesInteractor = getAppearancesInteractor
        self.router = router
    }
    
    /// Get all the appearances of a certain type of a character
    /// - Parameters:
    ///   - characterId: The ID of the character to get appearances
    ///   - appearanceType: The type of the appearances to get
    func getAppearances(characterId: Int, appearanceType: AppearanceType) {
        view?.startLoading()
        getAppearancesInteractor.getAppearances(characterId: characterId,
                                                appearanceType: appearanceType){ [weak self] (retrievedAppearances, errorMessage) in
            self?.view?.stopLoading()
            self?.manageGetAppearancesResponse(retrievedAppearances, errorMessage)
        }
    }
    
    /// Method that manages the response from network, filter and sort appearances and build view models to show
    /// - Parameters:
    ///   - retrievedAppearances: Appearances retrieved from interactor
    ///   - errorMessage: Error message to show if needed
    func manageGetAppearancesResponse(_ retrievedAppearances: [Appearance]?, _ errorMessage: String?) {
        if let appearances = retrievedAppearances {
            appearancesArray = appearances.filter { !$0.title.isEmpty }
            view?.showAppearances(buildAppearancesViewModels())
        } else {
            view?.showError(errorMessage)
        }
    }
    
    /// Method to build Appearances view model to show in the view
    /// - Returns: Appearances view model array
    func buildAppearancesViewModels() -> [AppearancesViewModel] {
        var appearancesViewModels = appearancesArray.compactMap {
            AppearanceToAppearancesViewModelMapper($0).map()
        }
        appearancesViewModels.sort { $0.title < $1.title }
        return appearancesViewModels
    }
    
    /// Navigation method to show a web from de Marvel website to show more details of the appearance.
    /// - Parameter appearanceId: The id of the appearance to show details
    func navigateToAppearanceDetail(_ appearanceId : Int) {
        appearancesArray.forEach {
            if ($0.id == appearanceId) {
                guard let url = $0.getDetailsUrl() else { return }
                router.navigateToURL(url)
            }
        }
    }
}
