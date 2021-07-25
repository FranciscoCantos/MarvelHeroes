//
//  GetCharacterInfoInteractorTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class GetCharacterInfoInteractorTests: XCTestCase {
    private var interactor: GetCharacterInfoInteractor!
    private var fakeRepository: CharactersRepositoryFake!
    private let characterId = 1011334

    func test_GetCharacterInfoSuccess() {
        loadCharacterInfoWithSuccess()
        let fakeRepositoryResponse = fakeRepository.fakeResponse?.characters.first
        
        interactor.getCharacterInfo(characterId: characterId) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNil(errorString)
        }
    }
    
    func test_GetCharacterInfoSuccess_EqualCharacterID() {
        loadCharacterInfoWithSuccess()
        
        interactor.getCharacterInfo(characterId: characterId) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse?.id, self.characterId)
        }
    }

    func test_GetCharacterInfoError() {
        loadCharacterInfoWithError()
        let fakeRepositoryResponse = fakeRepository.fakeResponse?.characters.first
        
        interactor.getCharacterInfo(characterId: characterId) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNotNil(errorString)
        }
    }
    
    // Helpers
    private func loadCharacterInfoWithSuccess() {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacterInfo")
        interactor = GetCharacterInfoInteractor(repository: fakeRepository)
        fakeRepository.getCharacterInfo(characterId: characterId) { _,_ in }
    }
    
    private func loadCharacterInfoWithError() {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacterInfo_bad")
        interactor = GetCharacterInfoInteractor(repository: fakeRepository)
        fakeRepository.getCharacterInfo(characterId: characterId) { _,_ in }
    }
}
