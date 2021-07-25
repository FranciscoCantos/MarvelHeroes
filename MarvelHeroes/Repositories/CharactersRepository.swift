//
//  CharactersRepository.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import Alamofire

typealias CharactersResponseCompletionBlock = (_ charactersResponse: CharactersResponse?, _ errorMessage: String?) -> Void
typealias CharacterResponseCompletionBlock = (_ charactersResponse: CharactersResponse?, _ errorMessage: String?) -> Void

protocol CharactersRepositoryProtocol {
    func getCharacters(completion: @escaping CharactersResponseCompletionBlock)
    func getCharacterInfo(characterId: Int, completion: @escaping CharacterResponseCompletionBlock)
    func searchCharacter(name: String, completion: @escaping CharactersResponseCompletionBlock)
}


/// Repository that makes calls to de Marvel API to get characters
class CharactersRepository: CharactersRepositoryProtocol {
    
    private var currentOffset: Int = 0
    
    /// Method to get the first amount of characters
    /// - Parameter completion: Retrieves an array of characters
    func getCharacters(completion: @escaping CharactersResponseCompletionBlock) {
        _ = try? AF.request(EndpointsConfiguration.getCharacters(offset: currentOffset).asURLRequest())
            .validate()
            .responseDecodable { (response: DataResponse<MarvelCharactersAPIResponse,AFError>) in
                switch response.result {
                case .success:
                    _ = response.result.map {
                        self.currentOffset += $0.data.count
                        completion($0.data, nil)
                    }
                case let .failure(error):
                    completion(nil, error.errorDescription)
                }
        }
    }
    
    /// Method to get a character detail info
    /// - Parameters:
    ///   - characterId: The Id of the character to get
    ///   - completion: Retrieves character info
    func getCharacterInfo(characterId: Int, completion: @escaping CharactersResponseCompletionBlock) {
        _ = try? AF.request(EndpointsConfiguration.getCharacterInfo(characterId: characterId).asURLRequest())
            .validate()
            .responseDecodable { (response: DataResponse<MarvelCharactersAPIResponse,AFError>) in
                switch response.result {
                case .success:
                    _ = response.result.map {
                        completion($0.data, nil)
                    }
                case let .failure(error):
                    completion(nil, error.errorDescription)
                }
        }
    }
    
    /// Method to search a caracter by name
    /// - Parameters:
    ///   - name: The name of the character to search
    ///   - completion: Retrieves character info if exists
    func searchCharacter(name: String, completion: @escaping CharactersResponseCompletionBlock) {
        _ = try? AF.request(EndpointsConfiguration.searchCharacter(name: name).asURLRequest())
            .validate()
            .responseDecodable { (response: DataResponse<MarvelCharactersAPIResponse,AFError>) in
                switch response.result {
                case .success:
                    _ = response.result.map {
                        completion($0.data, nil)
                    }
                case let .failure(error):
                    completion(nil, error.errorDescription)
                }
        }
    }

}

// Fake repository implementation used for testing. Get characters responses from JSON file
class CharactersRepositoryFake: CharactersRepositoryProtocol {
    private let fakeJSONName: String
    var fakeResponse: CharactersResponse?

    init(fakeJSONName: String) {
        self.fakeJSONName = fakeJSONName
    }
    
    private func getDataFromFakeJson() -> NSData? {
        guard let path = Bundle.main.path(forResource: fakeJSONName, ofType: "json") else {
            return nil
        }
        return NSData(contentsOf: URL(fileURLWithPath: path))
    }
        
    func getCharacters(completion: @escaping CharactersResponseCompletionBlock) {
        guard let data = getDataFromFakeJson() else {
            completion(nil, "Can't find \(fakeJSONName).json file")
            return
        }
        guard let response = try? JSONDecoder().decode(MarvelCharactersAPIResponse.self, from: data as Data) else {
            completion(nil, "Can't decode JSON response")
            return
        }
        fakeResponse = response.data
        completion(response.data, nil)
    }
    
    func getCharacterInfo(characterId: Int, completion: @escaping CharacterResponseCompletionBlock) {
        guard let data = getDataFromFakeJson() else {
            completion(nil, "Can't find \(fakeJSONName).json file")
            return
        }
        guard let response = try? JSONDecoder().decode(MarvelCharactersAPIResponse.self, from: data as Data) else {
            completion(nil, "Can't decode JSON response")
            return
        }
        fakeResponse = response.data
        completion(response.data, nil)
    }
    
    func searchCharacter(name: String, completion: @escaping CharactersResponseCompletionBlock) {
        guard let data = getDataFromFakeJson() else {
            completion(nil, "Can't find \(fakeJSONName).json file")
            return
        }
        guard let response = try? JSONDecoder().decode(MarvelCharactersAPIResponse.self, from: data as Data) else {
            completion(nil, "Can't decode JSON response")
            return
        }
        fakeResponse = response.data
        completion(response.data, nil)
    }
}
