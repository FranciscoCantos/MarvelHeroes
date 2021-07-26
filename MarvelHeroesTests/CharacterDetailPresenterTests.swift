//
//  CharacterDetailPresenterTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class CharacterDetailPresenterTests: XCTestCase {

    private class CharacterDetailViewControllerMock: CharacterDetailViewControllerProtocol {
        var showCharacterCalled = false
        var showErrorCalled = false
        var configureLoadingViewCalled = false
        var startLoadingCalled = false
        var stopLoadingCalled = false
        
        func showCharacter(_ characterViewModel: CharacterDetailViewModel) { showCharacterCalled = true }
        func showError(_ errorMessage: String?) { showErrorCalled = true }
        func configureLoadingView() { configureLoadingViewCalled = true }
        func startLoading() { startLoadingCalled = true }
        func stopLoading() { stopLoadingCalled = true }
    }
    
    private class GetCharacterInfoInteractorMock: GetCharacterInfoInteractorProtocol {
        var getCharacterInfoCalled = false
        
        func getCharacterInfo(characterId: Int, completion: @escaping GetCharacterInfoCompletionBlock) { getCharacterInfoCalled = true }
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
    private var mockGetCharacterInfoInteractor: GetCharacterInfoInteractorMock!
    private var mockView: CharacterDetailViewControllerMock!
    private var presenter: CharacterDetailPresenter!

    private let characterId: Int = 25
    
    override func setUp() {
        super.setUp()
        mockRouter = MainRouterMock()
        mockGetCharacterInfoInteractor = GetCharacterInfoInteractorMock()
        mockView = CharacterDetailViewControllerMock()
        
        presenter = CharacterDetailPresenter(router: mockRouter,
                                             getCharacterInfoInteractor: mockGetCharacterInfoInteractor,
                                             characterId: characterId)
        presenter.view = mockView
    }
    
    override func tearDown() {
        mockView = CharacterDetailViewControllerMock()
        super.tearDown()
    }
    
    func test_GetCharacterInfoInteractor() {
        presenter.showCharacterDetail()
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockGetCharacterInfoInteractor.getCharacterInfoCalled)
    }
    
    func test_ManageCharacterInfoResponse() {
        presenter.manageGetCharacterInfoResponse(buildCharacterToTest(), nil)
        XCTAssertEqual(buildCharacterToTest(), presenter.character)
        XCTAssertEqual(buildCharacterToTest().id, presenter.characterId)
        XCTAssertTrue(mockView.showCharacterCalled)
    }

    func test_ManageCharacterInfoResponseError() {
        presenter.manageGetCharacterInfoResponse(nil, "Error")
        XCTAssertTrue(mockView.showErrorCalled)
    }

    func test_BuildCharacterDetailViewModel() {
        XCTAssertNotNil(presenter.buildCharacterDetailViewModel(buildCharacterToTest()))
    }
    
    func test_NavigateToAppearances() {
        presenter.navigateToAppearances(characterId: 0, appearanceType: .comics)
        XCTAssertTrue(mockRouter.navigateToAppearancesCalled)
    }
    
    func test_NavigateToURL() {
        presenter.character = buildCharacterToTest()
        presenter.navigateToDetailInfo()
        XCTAssertTrue(mockRouter.navigateToURLCalled)
    }
    
    func test_NavigateToURLError() {
        presenter.character = nil
        presenter.navigateToDetailInfo()
        XCTAssertFalse(mockRouter.navigateToURLCalled)
    }
    
    private func buildCharacterToTest() -> Character {
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
        return character
    }
}
