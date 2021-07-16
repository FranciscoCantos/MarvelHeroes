//
//  AppearancesRepositoryTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class AppearancesRepositoryTests: XCTestCase {
    
    private var fakeRepository: AppearancesRepositoryFake!
    private var appearanceRepositoryResponse: [Appearance]?
    private var storiesRepositoryResponse: Story?
    private var repositoryError: String?
    
    //Mark - Empty Response
    func testGetAppearances_EmptyJSONResponse() throws {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "fake")
        fakeRepository.getAppearances(characterId: 0, apperanceType: .comics) { response, error in
            self.appearanceRepositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(appearanceRepositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    func testGetStoriesInfo_EmptyJSONResponse() throws {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "fake")
        fakeRepository.getStoriesInfo(storyId: 1) { response, error in
            self.storiesRepositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(storiesRepositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    // Mark - Response Successful
    
    func testGetAppearances_SuccessResponse() throws {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "GetAppearances")
        fakeRepository.getAppearances(characterId: 0, apperanceType: .comics) { response, error in
            self.appearanceRepositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNotNil(appearanceRepositoryResponse)
        XCTAssertTrue(appearanceRepositoryResponse?.count ?? 0 > 0)
        XCTAssertNil(repositoryError)
    }
    
    func testGetStoriesInfo_SuccessResponse() throws {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "GetStories")
        let storyId = 19947
        fakeRepository.getStoriesInfo(storyId: storyId) { response, error in
            self.storiesRepositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNotNil(storiesRepositoryResponse)
        XCTAssertEqual(storiesRepositoryResponse?.id, storyId)
        XCTAssertNil(repositoryError)
    }
    
    // Mark - Wrong Response

    func testGetAppearances_BadResponse() throws {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "GetAppearances_bad")
        fakeRepository.getAppearances(characterId: 0, apperanceType: .comics) { response, error in
            self.appearanceRepositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(appearanceRepositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
    
    func testGetStoriesInfo_BadResponse() throws {
        fakeRepository = AppearancesRepositoryFake(fakeJSONName: "GetStories_bad")
        fakeRepository.getStoriesInfo(storyId: 19947) { response, error in
            self.storiesRepositoryResponse = response
            self.repositoryError = error
        }
        XCTAssertNil(storiesRepositoryResponse)
        XCTAssertNotNil(repositoryError)
    }
}
