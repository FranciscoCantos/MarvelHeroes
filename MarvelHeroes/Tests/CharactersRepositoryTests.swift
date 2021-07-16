//
//  CharactersRepositoryTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class CharactersRepositoryTests: XCTestCase {
    
    private var fakeRepository: CharactersRepositoryFake!
    private var repositoryResponse: CharactersResponse?
    private var repositoryError: String?
    
    //Mark - Empty Response

    func testGetCharacters_EmptyJSONResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "fake")
        fakeRepository.getCharacters { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(repositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    
    func testGetCharacterInfo_EmptyJSONResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "fake")
        fakeRepository.getCharacterInfo(characterId: 0) { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(repositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    func testSearchCharacter_EmptyJSONResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "fake")
        fakeRepository.searchCharacter(name: "") { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(repositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    // Mark - Response Successful
    
    func testGetCharacters_SuccessResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacters")
        fakeRepository.getCharacters { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNotNil(repositoryResponse)
        XCTAssertTrue(repositoryResponse?.characters.count ?? 0 > 0)
        XCTAssertNil(repositoryError)
    }
    
    func testGetCharacterInfo_SuccessResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacterInfo")
        let characterId = 1011334
        fakeRepository.getCharacterInfo(characterId: characterId) { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNotNil(repositoryResponse)
        XCTAssertTrue(repositoryResponse?.characters.count ?? 0 == 1)
        XCTAssertEqual(repositoryResponse?.characters.first?.id, characterId)
        XCTAssertNil(repositoryError)
    }
    
    func testSearchCharacter_SuccessResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "SearchCharacter")
        let characterName = "Wolverine"
        fakeRepository.searchCharacter(name: characterName) { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNotNil(repositoryResponse)
        XCTAssertTrue(repositoryResponse?.characters.count ?? 0 == 1)
        XCTAssertEqual(repositoryResponse?.characters.first?.name, characterName)
        XCTAssertNil(repositoryError)
    }
    
    // Mark - Wrong Response

    func testGetCharacters_BadResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacters_bad")
        fakeRepository.getCharacters { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(repositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    func testGetCharacterInfo_BadResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "GetCharacterInfo_bad")
        fakeRepository.getCharacterInfo(characterId: 0) { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(repositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    func testSearchCharacter_BadResponse() throws {
        fakeRepository = CharactersRepositoryFake(fakeJSONName: "SearchCharacter_bad")
        fakeRepository.searchCharacter(name: "") { response, error in
            self.repositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(repositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
}
