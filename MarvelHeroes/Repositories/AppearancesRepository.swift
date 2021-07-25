//
//  AppearancesRepository.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import Alamofire

typealias AppearancesResponseCompletionBlock = (_ appearancesResponse: [Appearance]?, _ errorMessage: String?) -> Void
typealias StoryInfoResponseCompletionBlock = (_ storyResponse: Story?, _ errorMessage: String?) -> Void

protocol AppearancesRepositoryProtocol {
    func getAppearances(characterId: Int, apperanceType: AppearanceType, completion: @escaping AppearancesResponseCompletionBlock)
    func getStoriesInfo(storyId: Int, completion: @escaping StoryInfoResponseCompletionBlock)

}

/// Repository that makes calls to de Marvel API to get appearances
class AppearancesRepository: AppearancesRepositoryProtocol {
    private var totalElements: Int = 0
    private var offset: Int = 0
    
    /// Method that gets all the appearances of a character by type
    /// - Parameters:
    ///   - characterId: The ID of the character to get appearances
    ///   - apperanceType: The appearances type to get
    ///   - completion: Gets all the appearances of a character
    func getAppearances(characterId: Int, apperanceType: AppearanceType, completion: @escaping AppearancesResponseCompletionBlock) {
        repeat {
            let endpointConfig = getEndpointConfiguration(characterId: characterId, appearanceType: apperanceType)
            _ = try? AF.request(endpointConfig.asURLRequest())
                .validate()
                .responseDecodable { (response: DataResponse<MarvelItemsAPIResponse,AFError>) in
                    switch response.result {
                    case .success:
                        _ = response.result.map {
                            self.offset += $0.data.count 
                            self.totalElements = $0.data.total
                            completion($0.data.results, nil)
                        }
                    case let .failure(error):
                        completion(nil, error.errorDescription)
                    }
                }
        } while totalElements > offset
    }
    

    /// Method that gets all the Stories of a character. Needed to gets certain params to be used on details views
    /// - Parameters:
    ///   - storyId: The ID of the story to get details
    ///   - completion: Get all the details of a Story
    func getStoriesInfo(storyId: Int, completion: @escaping StoryInfoResponseCompletionBlock) {
        _ = try? AF.request(EndpointsConfiguration.getStoryInfo(storyId: storyId).asURLRequest())
            .validate()
            .responseDecodable { (response: DataResponse<MarvellStoriesAPIResponse,AFError>) in
                switch response.result {
                case .success:
                    _ = response.result.map {
                        completion($0.data.results.first, nil)
                    }
                case let .failure(error):
                    completion(nil, error.errorDescription)
                }
            }
    }
    
    /// Private method to get the endpoint configuration for the different types of stories
    /// - Parameters:
    ///   - characterId: The ID of the character to get appearances
    ///   - apperanceType: The appearances type to get
    /// - Returns: The needed configuration.
    private func getEndpointConfiguration(characterId: Int, appearanceType: AppearanceType) -> EndpointsConfiguration {
        switch appearanceType {
        case .comics:
            return EndpointsConfiguration.getComics(characterId: characterId, offset: offset)
        case .events:
            return EndpointsConfiguration.getEvents(characterId: characterId, offset: offset)
        case .series:
            return EndpointsConfiguration.getSeries(characterId: characterId, offset: offset)
        case .stories:
            return EndpointsConfiguration.getStories(characterId: characterId, offset: offset)
        }
    }
    
}

// Fake repository implementation used for testing. Get appearances responses from JSON file.
class AppearancesRepositoryFake: AppearancesRepositoryProtocol {
    private let fakeJSONName: String
    var fakeResponse: [Appearance]?
    var getStoriesCalled: Bool = false
    
    init(fakeJSONName: String) {
        self.fakeJSONName = fakeJSONName
    }
    
    private func getDataFromFakeJson() -> NSData? {
        guard let path = Bundle.main.path(forResource: fakeJSONName, ofType: "json") else {
            return nil
        }
        return NSData(contentsOf: URL(fileURLWithPath: path))
    }
    
    func getAppearances(characterId: Int, apperanceType: AppearanceType, completion: @escaping AppearancesResponseCompletionBlock) {
        guard let data = getDataFromFakeJson() else {
            completion(nil, "Can't find \(fakeJSONName).json file")
            return
        }
        guard let response = try? JSONDecoder().decode(MarvelItemsAPIResponse.self, from: data as Data) else {
            completion(nil, "Can't decode JSON response")
            return
        }
        fakeResponse = response.data.results
        if apperanceType == .stories {
            getStoriesInfo(storyId: response.data.results.first?.id ?? 0) { _, _ in }
        }
        completion(response.data.results, nil)
    }
    
    func getStoriesInfo(storyId: Int, completion: @escaping StoryInfoResponseCompletionBlock) {
        guard let data = getDataFromFakeJson() else {
            completion(nil, "Can't find \(fakeJSONName).json file")
            return
        }
        guard let response = try? JSONDecoder().decode(MarvellStoriesAPIResponse.self, from: data as Data) else {
            completion(nil, "Can't decode JSON response")
            return
        }
        getStoriesCalled = true
        completion(response.data.results.first, nil)
    }
}
