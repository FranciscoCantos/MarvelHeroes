//
//  AppearancesPresenter.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit

protocol AppearancesPresenterProtocol {
    func getAppearances(characterId: Int, apperanceType: AppearanceType)
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
    ///   - apperanceType: The type of the appearances to get
    func getAppearances(characterId: Int, apperanceType: AppearanceType) {
        view?.startLoading()
        getAppearancesInteractor.getAppearances(characterId: characterId,
                                                apperanceType: apperanceType){ [weak self] (retrievedAppearances, errorMessage) in
            self?.view?.stopLoading()
            if let appearances = retrievedAppearances {
                self?.appearancesArray = appearances.filter { !$0.title.isEmpty }
                var appearancesViewModels = self?.appearancesArray.compactMap {
                    AppearanceToAppearancesViewModelMapper($0).map()
                }
                appearancesViewModels?.sort { $0.title < $1.title }
                self?.view?.showAppearances(appearancesViewModels ?? [])
            } else {
                self?.view?.showError(errorMessage)
            }
        }
    }
    
    
    /// Navigation method to show a web from de Marvel website to show more details of the appearance.
    /// - Parameter appearanceId: The id of the appearance to show details
    func navigateToAppearanceDetail(_ appearanceId : Int) {
        appearancesArray.forEach {
            if ($0.id == appearanceId) {
                guard let url = $0.getDetailsUrl() else { return }
                UIApplication.shared.open(url)
            }
        }
    }
}
