//
//  GetAppearancesInteractor.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

typealias GetAppearancesCompletionBlock = (_ appearances: [Appearance]?, _ errorMessage: String?) -> Void

protocol GetAppearancesInteractorProtocol {
    func getAppearances(characterId: Int, appearanceType: AppearanceType, completion: @escaping GetAppearancesCompletionBlock)
}


/// Interactor that gets the appearances of a character given.
/// Some appearances types like Stories need a more detailed call to get params like thumbnail.
class GetAppearancesInteractor: GetAppearancesInteractorProtocol {
    private let repository: AppearancesRepositoryProtocol
    
    init(repository: AppearancesRepositoryProtocol) {
        self.repository = repository
    }
    
    
    /// Retrieves the appearances of a certain type of the given character
    /// - Parameters:
    ///   - characterId: Id of the character to get the appearances
    ///   - appearanceType: The type of the appearance
    ///   - completion: Retrieves all the appearances info of a type
    func getAppearances(characterId: Int, appearanceType: AppearanceType, completion: @escaping GetAppearancesCompletionBlock) {
        repository.getAppearances(characterId: characterId, appearanceType: appearanceType) { (response, errorMessage) in
            if let appearancesResponse = response {
                if appearanceType == .stories {
                    completion(self.getStoriesInfo(stories: appearancesResponse), nil)
                }
                completion(appearancesResponse, nil)
            } else {
                completion(nil, errorMessage)
            }
        }
    }
    
    
    ///  Get the info of a story. This appearance type has some peculiarity and need a custom method to get certain info like thumbnail
    /// - Parameter stories: The id of the story
    /// - Returns: Gets the full story info.
    private func getStoriesInfo(stories: [Appearance]) -> [Appearance] {
        var result: [Appearance] = []
        stories.forEach { story in
            repository.getStoriesInfo(storyId: story.id) { (response, errorMessage) in
                if let appearancesResponse = response {
                    result.append(Appearance(id: appearancesResponse.id,
                                             title: appearancesResponse.title,
                                             description: appearancesResponse.description ?? "",
                                             urls: appearancesResponse.urls,
                                             thumbnail: appearancesResponse.thumbnail))
                }
            }
        }
        return result
    }
    
}
