//
//  SearchCharacterInteractorTest.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class SearchCharacterInteractorTest: XCTestCase {
    private var interactor: SearchCharacterInteractor!
    private var fakeRepository: CharactersRepositoryFake!
    private let characterName: String = "Wolverine"

    func test_SearchCharacterSuccess() {
        loadSearchCharacterSuccess()
        let fakeRepositoryResponse = fakeRepository.fakeResponse?.characters
        
        interactor.searchCharacter(name: characterName) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNil(errorString)
        }
    }
    
    func test_SearchCharacterSuccess_EqualCharacterName() {
        loadSearchCharacterSuccess()
        
        interactor.searchCharacter(name: characterName) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse?.first?.name, self.characterName)
        }
    }

    func test_SearchCharacterError() {
        loadSearchCharacterError()
        let fakeRepositoryResponse = fakeRepository.fakeResponse?.characters
        
        interactor.searchCharacter(name: characterName) { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNotNil(errorString)
        }
    }
    
    // Helpers
    private func loadSearchCharacterSuccess() {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "SearchCharacter")
        interactor = SearchCharacterInteractor(repository: fakeRepository)
        fakeRepository.searchCharacter(name: characterName) { _,_ in }
    }
    
    private func loadSearchCharacterError() {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "SearchCharacter_bad")
        interactor = SearchCharacterInteractor(repository: fakeRepository)
        fakeRepository.searchCharacter(name: characterName) { _,_ in }
    }
}
