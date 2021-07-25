//
//  GetCharactersInteractorTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class GetCharactersInteractorTests: XCTestCase {
    private var interactor: GetCharactersInteractor!
    private var fakeRepository: CharactersRepositoryFake!

    func test_GetCharactersSuccess() {
        loadCharactersListWithSuccess()
        let fakeRepositoryResponse = fakeRepository.fakeResponse?.characters

        interactor.getCharacters { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNil(errorString)
        }
    }

    func test_GetCharactersError() {
        loadCharactersListWithError()
        let fakeRepositoryResponse = fakeRepository.fakeResponse?.characters

        interactor.getCharacters { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, fakeRepositoryResponse)
            XCTAssertNotNil(errorString)
        }
    }
    
    // Helpers
    private func loadCharactersListWithSuccess() {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacters")
        interactor = GetCharactersInteractor(repository: fakeRepository)
        fakeRepository.getCharacters { _,_ in }
    }
    
    private func loadCharactersListWithError() {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacters_bad")
        interactor = GetCharactersInteractor(repository: fakeRepository)
        fakeRepository.getCharacters { _,_ in }
    }
}
