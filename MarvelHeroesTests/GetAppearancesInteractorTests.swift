//
//  GetAppearancesInteractorTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class GetAppearancesInteractorTests: XCTestCase {
    private var interactor: GetAppearancesInteractor!
    private var fakeRepository: AppearancesRepositoryFake!
    private let characterId = 22506
    private var appearanceType = AppearanceType.comics
    
    func test_GetAppearancesSuccess() {
        loadGetAppearancesSuccess()
        let fakeRepositoryResponse = fakeRepository.fakeResponse

        interactor.getAppearances(characterId: characterId, apperanceType: appearanceType) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNil(errorString)
        }
    }
    
    func test_GetAppearancesError() {
        loadGetAppearancesError()
        let fakeRepositoryResponse = fakeRepository.fakeResponse
        
        interactor.getAppearances(characterId: characterId, apperanceType: appearanceType) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNotNil(errorString)
        }
    }
    
    func test_GetStoriesCalled() {
        appearanceType = .stories
        loadGetAppearancesSuccess()
        XCTAssertTrue(fakeRepository.getStoriesCalled)
    }
    
    // Helpers
    private func loadGetAppearancesSuccess() {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "GetAppearances")
        interactor = GetAppearancesInteractor(repository: fakeRepository)
        fakeRepository.getAppearances(characterId: characterId, apperanceType: appearanceType) { _,_ in }
    }
    
    private func loadGetAppearancesError() {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "GetAppearances_bad")
        interactor = GetAppearancesInteractor(repository: fakeRepository)
        fakeRepository.getAppearances(characterId: characterId, apperanceType: appearanceType) { _,_ in }
    }
}
