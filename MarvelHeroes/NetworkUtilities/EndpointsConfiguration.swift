//
//  EndpointsConfiguration.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import Alamofire

// Endpoint configuration implementation.
enum EndpointsConfiguration: APIConfiguration {
        
    case getCharacters
    case getMoreCharacters(offset: Int)
    case getCharacterInfo(characterId: Int)
    case searchCharacter(name: String)
    case getComics(characterId: Int, offset: Int)
    case getEvents(characterId: Int, offset: Int)
    case getSeries(characterId: Int, offset: Int)
    case getStories(characterId: Int, offset: Int)
    case getStoryInfo(storyId: Int)
 
    // HTTPMethods
    var method: HTTPMethod {
        switch self {
        case .getCharacters, .getCharacterInfo, .getMoreCharacters, .searchCharacter,
             .getComics, .getEvents, .getSeries, .getStories, .getStoryInfo:
            return .get
        }
    }
    
    // Paths
    var path: String {
        switch self {
        case .getCharacters, .getMoreCharacters, .searchCharacter:
            return "/v1/public/characters"
        case .getCharacterInfo(let characterId):
            return "/v1/public/characters/\(characterId)"
        case .getComics(let characterId, _):
            return "/v1/public/characters/\(characterId)/comics"
        case .getStories(let characterId, _):
            return "/v1/public/characters/\(characterId)/stories"
        case .getEvents(let characterId, _):
            return "/v1/public/characters/\(characterId)/events"
        case .getSeries(let characterId, _):
            return "/v1/public/characters/\(characterId)/series"
        case .getStoryInfo(let storyId):
            return "/v1/public/stories/\(storyId)"
        }
    }
    
    // Query Items
    var queryItems: [URLQueryItem] {
        var defaultQueryItems = [URLQueryItem(name: "ts", value: "1"),
                                 URLQueryItem(name: "apikey", value: ApiKeys.publicKey),
                                 URLQueryItem(name: "hash", value: md5HashValue), URLQueryItem(name: "limit", value: "100")]
        switch self {
        case .getCharacters, .getCharacterInfo, .getStoryInfo:
            return defaultQueryItems
        case .getMoreCharacters(offset: let offset):
            defaultQueryItems.append(contentsOf: [URLQueryItem(name: "offset", value: "\(offset)")])
            return defaultQueryItems
        case .searchCharacter(name: let name):
            defaultQueryItems.append(contentsOf: [URLQueryItem(name: "name", value: "\(name)")])
            return defaultQueryItems
        case .getComics(values: let values), .getEvents(values: let values), .getSeries(values: let values), .getStories(values: let values):
            defaultQueryItems.append(contentsOf: [URLQueryItem(name: "offset", value: "\(values.offset)")])
            return defaultQueryItems
        }
    }
        
    //URLRequest 
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: MarvelBaseURL)!
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return urlRequest
    }
}
