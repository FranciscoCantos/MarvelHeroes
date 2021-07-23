//
//  GetCharactersInteractorTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class GetCharactersInteractorTests: XCTestCase {
    
    struct CharactersResponseResult {
        static let errorResult: CharactersResponse? = nil
        static let successfulResult: CharactersResponse = successfulResponse()
        static let successfulResponse = { () -> CharactersResponse in
            let thumbnail = Thumbnail(path: "path", thumbnailExtension: "extension")
            
            let comic = ComicsItem(resourceURI: "resourceURI", name: "ComicName")
            let comics = Comics(available: 0, collectionURI: "resourceURI", items: [comic], returned: 1)
            
            let serie = SeriesItem(resourceURI: "resourceURI", name: "ComicName")
            let series = Series(available: 0, collectionURI: "resourceURI", items: [serie], returned: 1)
            
            let story = StoriesItem(resourceURI: "resourceURI", name: "ComicName", type: "A")
            let stories = Stories(available: 0, collectionURI: "resourceURI", items: [story], returned: 1)
            
            let event = EventsItem(resourceURI: "resourceURI", name: "ComicName")
            let events = Events(available: 0, collectionURI: "resourceURI", items: [event], returned: 1)
            
            let url = URLElement(type: "urlType", url: "url")
            
            let character1 = Character(id: 0,
                                       name: "character0",
                                       characterDescription: "characterDescription0",
                                       thumbnail: thumbnail,
                                       resourceURI: "resourceURI",
                                       comics: comics,
                                       series: series,
                                       stories: stories,
                                       events: events,
                                       urls: [url])
            
            let response = CharactersResponse(offset: 0, limit: 1, total: 1, count: 1,
                                              characters: [character1])
            
            return response
        }
        
    }
    
    class FakeRepository: CharactersRepositoryProtocol {
        var result: CharactersResponse?
        
        func getCharacters(completion: @escaping CharactersResponseCompletionBlock) {
            guard let result = result else {
                return completion(result, "Didn't supply fake result")
            }
            completion(result, nil)
        }
        
        func getCharacterInfo(characterId: Int, completion: @escaping CharacterResponseCompletionBlock) {
            guard let result = result else {
                return completion(result, "Didn't supply fake result")
            }
            completion(result, nil)
        }
        
        func searchCharacter(name: String, completion: @escaping CharactersResponseCompletionBlock) {
            guard let result = result else {
                return completion(result, "Didn't supply fake result")
            }
            completion(result, nil)
        }
    }
    
    var interactor: GetCharactersInteractor!
    let repository = FakeRepository()
    var fakeCharactersResponse: [Character] {
        return getFakeInteractorCharactersResponse()
    }
    
    override func setUp() {
        super.setUp()
        interactor = GetCharactersInteractor(repository: repository)
    }
    
    func test_LoadCharacterWithSuccess_GetCharactersSuccess() {
        loadCharactersListWithSuccess()
        
        interactor.getCharacters { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, CharactersResponseResult.successfulResponse().characters)
            XCTAssertNil(errorString)
        }
    }

    func test_LoadCharacterWithError_GetCharactersError() {
        loadCharactersListWithError()
        
        interactor.getCharacters { repositoryResponse, errorString in
            XCTAssertEqual(repositoryResponse, CharactersResponseResult.errorResult?.characters)
            XCTAssertNotNil(errorString)
        }
    }
    
    // Helpers
    private func getFakeInteractorCharactersResponse() -> [Character] {
        let thumbnail = Thumbnail(path: "path", thumbnailExtension: "extension")
        
        let comic = ComicsItem(resourceURI: "resourceURI", name: "ComicName")
        let comics = Comics(available: 0, collectionURI: "resourceURI", items: [comic], returned: 1)
        
        let serie = SeriesItem(resourceURI: "resourceURI", name: "ComicName")
        let series = Series(available: 0, collectionURI: "resourceURI", items: [serie], returned: 1)
        
        let story = StoriesItem(resourceURI: "resourceURI", name: "ComicName", type: "A")
        let stories = Stories(available: 0, collectionURI: "resourceURI", items: [story], returned: 1)
        
        let event = EventsItem(resourceURI: "resourceURI", name: "ComicName")
        let events = Events(available: 0, collectionURI: "resourceURI", items: [event], returned: 1)
        
        let url = URLElement(type: "urlType", url: "url")
        
        let character1 = Character(id: 0,
                                   name: "character0",
                                   characterDescription: "characterDescription0",
                                   thumbnail: thumbnail,
                                   resourceURI: "resourceURI",
                                   comics: comics,
                                   series: series,
                                   stories: stories,
                                   events: events,
                                   urls: [url])
        
        let character2 = Character(id: 2,
                                   name: "character2",
                                   characterDescription: "characterDescription2",
                                   thumbnail: thumbnail,
                                   resourceURI: "resourceURI2",
                                   comics: comics,
                                   series: series,
                                   stories: stories,
                                   events: events,
                                   urls: [url])
        
        return [character1, character2]
    }
    
    private func getFakeRepositoryCharactersResponse() -> CharactersResponse {
        let thumbnail = Thumbnail(path: "path", thumbnailExtension: "extension")
        
        let comic = ComicsItem(resourceURI: "resourceURI", name: "ComicName")
        let comics = Comics(available: 0, collectionURI: "resourceURI", items: [comic], returned: 1)
        
        let serie = SeriesItem(resourceURI: "resourceURI", name: "ComicName")
        let series = Series(available: 0, collectionURI: "resourceURI", items: [serie], returned: 1)
        
        let story = StoriesItem(resourceURI: "resourceURI", name: "ComicName", type: "A")
        let stories = Stories(available: 0, collectionURI: "resourceURI", items: [story], returned: 1)
        
        let event = EventsItem(resourceURI: "resourceURI", name: "ComicName")
        let events = Events(available: 0, collectionURI: "resourceURI", items: [event], returned: 1)
        
        let url = URLElement(type: "urlType", url: "url")
        
        let character1 = Character(id: 0,
                                   name: "character0",
                                   characterDescription: "characterDescription0",
                                   thumbnail: thumbnail,
                                   resourceURI: "resourceURI",
                                   comics: comics,
                                   series: series,
                                   stories: stories,
                                   events: events,
                                   urls: [url])
        
        let response = CharactersResponse(offset: 0, limit: 1, total: 1, count: 1,
                                          characters: [character1])
        
        return response
    }
    
    private func loadCharactersListWithSuccess() {
        repository.result = CharactersResponseResult.successfulResult
    }
    
    private func loadCharactersListWithError() {
        repository.result = CharactersResponseResult.errorResult
    }
}
