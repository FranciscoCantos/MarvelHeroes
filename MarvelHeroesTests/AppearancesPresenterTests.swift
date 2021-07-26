//
//  AppearancesPresenterTests.swift
//  MarvelHeroesTests
//
//  Created by Francisco Cantos
//

import XCTest
@testable import MarvelHeroes

class AppearancesPresenterTests: XCTestCase {

    private class AppearancesViewControllerMock: AppearancesViewControllerProtocol {
        var showAppearancesCalled = false
        var showErrorCalled = false
        var configureLoadingViewCalled = false
        var startLoadingCalled = false
        var stopLoadingCalled = false

        func showAppearances(_ appearances: [AppearancesViewModel]) { showAppearancesCalled = true }
        func showError(_ errorMessage: String?) { showErrorCalled = true }
        func configureLoadingView() { configureLoadingViewCalled = true }
        func startLoading() { startLoadingCalled = true }
        func stopLoading() { stopLoadingCalled = true }
    }
    
    private class GetAppearancesInteractorMock: GetAppearancesInteractorProtocol {
        var getAppearancesCalled = false
        
        func getAppearances(characterId: Int, appearanceType: AppearanceType, completion: @escaping GetAppearancesCompletionBlock) { getAppearancesCalled = true }
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
    private var mockGetAppearancesInteractorInteractor: GetAppearancesInteractorMock!
    private var mockView: AppearancesViewControllerMock!
    private var presenter: AppearancesPresenter!
    
    private let characterId: Int = 25
    private let appearanceType = AppearanceType.comics

    
    override func setUp() {
        super.setUp()
        mockRouter = MainRouterMock()
        mockGetAppearancesInteractorInteractor = GetAppearancesInteractorMock()
        mockView = AppearancesViewControllerMock()
        
        presenter = AppearancesPresenter(router: mockRouter,
                                         getAppearancesInteractor: mockGetAppearancesInteractorInteractor)
        presenter.view = mockView
    }
    
    override func tearDown() {
        mockView = AppearancesViewControllerMock()
        super.tearDown()
    }
    
    func test_GetAppearanceInteractor() {
        presenter.getAppearances(characterId: characterId, appearanceType: appearanceType)
        XCTAssertTrue(mockView.startLoadingCalled)
        XCTAssertTrue(mockGetAppearancesInteractorInteractor.getAppearancesCalled)
    }
    
    func test_ManageAppearancesResponse() {
        presenter.manageGetAppearancesResponse(buildAppearancesToTest(), nil)
        XCTAssertEqual(buildAppearancesToTest(), presenter.appearancesArray)
        XCTAssertTrue(mockView.showAppearancesCalled)
    }

    func test_ManageCharacterInfoResponseError() {
        presenter.manageGetAppearancesResponse(nil, "Error")
        XCTAssertTrue(mockView.showErrorCalled)
    }

    func test_BuildCharacterDetailViewModel() {
        XCTAssertNotNil(presenter.buildAppearancesViewModels())
    }
    
    func test_NavigateToURL() {
        presenter.appearancesArray = buildAppearancesToTest()
        presenter.navigateToAppearanceDetail(presenter.appearancesArray.first?.id ?? 0)
        XCTAssertTrue(mockRouter.navigateToURLCalled)
    }
    
    func test_NavigateToURLError() {
        presenter.appearancesArray = []
        presenter.navigateToAppearanceDetail(0)
        XCTAssertFalse(mockRouter.navigateToURLCalled)
    }
    
    private func buildAppearancesToTest() -> [Appearance] {
        let urlElement = URLElement(type: "detail", url: "www.google.com")
        let thumnail = Thumbnail(path: "thumbnailPath", thumbnailExtension: "thumbnailExtension")
        
        let appearance = Appearance(id: 25,
                                    title: "appearanceTitle",
                                    description: "description",
                                    urls: [urlElement],
                                    thumbnail: thumnail)
        
        let appearance2 = Appearance(id: 45,
                                    title: "appearanceTitle2",
                                    description: "description2",
                                    urls: [urlElement],
                                    thumbnail: thumnail)
        
        return [appearance, appearance2]
    }
}
