//
//  CharactersPresenterTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class CharactersPresenterTests: XCTestCase {
    
    private class CharactersViewControllerMock: CharactersViewControllerProtocol {
        var showCharactersCalled = false
        var showSearchedCharactersCalled = false
        var showErrorCalled = false
        var configureLoadingViewCalled = false
        var startLoadingCalled = false
        var stopLoadingCalled = false

        func showCharacters(_ characters: [CharacterListViewModel]) { showCharactersCalled = true}
        func showSearchedCharacters(_ characters: [CharacterListViewModel]) {  showSearchedCharactersCalled = true }
        func showError(_ errorMessage: String?) { showErrorCalled = true }
        func configureLoadingView() { configureLoadingViewCalled = true }
        func startLoading() { startLoadingCalled = true }
        func stopLoading() { stopLoadingCalled = true }
    }
    
    private class GetCharactersInteractorMock: GetCharactersInteractorProtocol {
        var getCharactersCalled = false
        
        func getCharacters(completion: @escaping GetCharactersCompletionBlock) { getCharactersCalled = true }
    }
    
    private class SearchCharacterInteractorMock: SearchCharacterInteractorProtocol {
        var searchCharacterCalled = false
        
        func searchCharacter(name: String, completion: @escaping GetCharactersCompletionBlock) { searchCharacterCalled = true }
    }
    
    private class MainRouterMock: MainRouterProtocol {
        var navigateToURLCalled = false
        var navigateToCharacterDetailCalled = false
        var navigateToAppearancesCalled = false
        
        func navigateToCharacterDetail(_ characterId: Int) { navigateToCharacterDetailCalled = true }
        func navigateToAppearances(characterId: Int, appearanceType: AppearanceType) { navigateToAppearancesCalled = true }
        func navigateToURL(_ url: URL) { navigateToURLCalled = true }
    }
    
    private var mockRouter: MainRouterMock!
    private var mockGetCharactersInteractor: GetCharactersInteractorMock!
    private var mockSearchCharacterInteractor: SearchCharacterInteractorMock!
    private var mockView: CharactersViewControllerMock!
    private var presenter: CharactersPresenter!
    
    override func setUp() {
        super.setUp()
        mockRouter = MainRouterMock()
        mockGetCharactersInteractor = GetCharactersInteractorMock()
        mockSearchCharacterInteractor = SearchCharacterInteractorMock()
        mockView = CharactersViewControllerMock()
        
        presenter = CharactersPresenter(router: mockRouter,
                                        getCharactersInteractor: mockGetCharactersInteractor,
                                        searchCharacterInteractor: mockSearchCharacterInteractor)
        presenter.view = mockView
    }
    
    override func tearDown() {
        mockView = CharactersViewControllerMock()
        super.tearDown()
    }
    
    func test_GetCharactersInteractor() {
        presenter.getCharacters()
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockGetCharactersInteractor.getCharactersCalled)
    }
    
    func test_SearchCharacterInteractor() {
        presenter.searchCharacters(name: "Wolverine")
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockSearchCharacterInteractor.searchCharacterCalled)
    }
    
    func test_ManageCharactersResponse() {
        presenter.manageCharactersResponse(buildCharactersToTest(), nil)
        XCTAssertEqual(buildCharactersToTest(), presenter.charactersArray)
        XCTAssertTrue(mockView.showCharactersCalled)
    }
    
    func test_ManageCharactersResponseError() {
        presenter.manageCharactersResponse(nil, "Error")
        XCTAssertEqual(presenter.charactersArray, [])
        XCTAssertTrue(mockView.showErrorCalled)
    }
    
    func test_ManageCharactersResponseEmpty() {
        presenter.manageCharactersResponse([], nil)
        XCTAssertEqual(presenter.charactersArray, [])
        XCTAssertTrue(mockView.showCharactersCalled)
    }
    
    func test_ManageSearchCharactersResponse() {
        presenter.manageSearchCharactersResponse(buildCharactersToTest(), nil)
        XCTAssertTrue(mockView.showSearchedCharactersCalled)
    }
    
    func test_ManageSearchCharactersResponseError() {
        presenter.manageSearchCharactersResponse(nil, "Error")
        XCTAssertEqual(presenter.charactersArray, [])
        XCTAssertTrue(mockView.showErrorCalled)
    }
    
    func test_ManageSearchCharactersResponseEmpty() {
        presenter.manageSearchCharactersResponse([], nil)
        XCTAssertEqual(presenter.charactersArray, [])
        XCTAssertTrue(mockView.showSearchedCharactersCalled)
    }
    
    func test_BuildCharacterViewModels() {
        XCTAssertNotNil(presenter.buildCharacterViewModels(buildCharactersToTest()))
        XCTAssertEqual(presenter.buildCharacterViewModels(buildCharactersToTest()).count, buildCharactersToTest().count)
    }
    
    func test_navigateToCharacterDetailCalled() {
        let characterViewModel = CharacterListViewModel(name: "", imageURL: "", id: 0)
        presenter.navigateToCharacterDetail(character: characterViewModel)
        XCTAssertTrue(mockRouter.navigateToCharacterDetailCalled)
    }
    
    private func buildCharactersToTest() -> [Character] {
        let urlElement = URLElement(type: "detail", url: "www.google.com")
        let thumnail = Thumbnail(path: "thumbnailPath", thumbnailExtension: "thumbnailExtension")
        let comic = ComicsItem(resourceURI: "comicItemUri", name: "comicName")
        let comics = Comics(available: 1, collectionURI: "collectionURI", items: [comic], returned: 1)
        let serie = SeriesItem(resourceURI: "resourceURI", name: "name")
        let series = Series(available: 1, collectionURI: "collectionURI", items: [serie], returned: 1)
        let storie = StoriesItem(resourceURI: "resourceURI", name: "name", type: "type")
        let stories = Stories(available: 1, collectionURI: "collectionURI", items: [storie], returned: 1)
        let event = EventsItem(resourceURI: "resourceURI", name: "name")
        let events = Events(available: 1, collectionURI: "collectionURI", items: [event], returned: 1)
        
        let character = Character(id: 25,
                                  name: "characterName",
                                  characterDescription: "characterName",
                                  thumbnail: thumnail,
                                  resourceURI: "characterName",
                                  comics: comics,
                                  series: series,
                                  stories: stories,
                                  events: events,
                                  urls: [urlElement])
        
        let character2 = Character(id: 35,
                                   name: "characterName",
                                  characterDescription: "characterName",
                                  thumbnail: thumnail,
                                  resourceURI: "characterName",
                                  comics: comics,
                                  series: series,
                                  stories: stories,
                                  events: events,
                                  urls: [urlElement])
        
        return [character, character2]
    }
    
    private func buildCharactersViewModelsToTest() -> [CharacterListViewModel] {
        return buildCharactersToTest().compactMap {
            CharacterToCharacterListViewModelMapper($0).map()
        }
    }
}
