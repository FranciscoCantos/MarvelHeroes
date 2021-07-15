//
//  MarvelAPIEntites.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

// MARK: - MarvelCharactersAPIResponse
struct MarvelCharactersAPIResponse: Codable {
    let data: CharactersResponse
}

// MARK: - MarvelItemsAPIResponse
struct MarvelItemsAPIResponse: Codable {
    let data: AppearanceResponse
}

// MARK: - MarvellStoriesAPIResponse
struct MarvellStoriesAPIResponse: Codable {
    let data: StoryResults
}

// MARK: - DataClass
struct StoryResults: Codable {
    let results: [Story]
}

// MARK: - AppearanceResponse
struct AppearanceResponse: Codable {
    let offset, limit, total, count: Int
    let results: [Appearance]
}

// MARK: - AppearanceItem
struct Appearance: Codable {
    let id: Int
    let title: String
    let description: String?
    let urls: [URLElement]?
    let thumbnail: Thumbnail?
    
    enum CodingKeys: String, CodingKey {
        case id, title, urls
        case thumbnail = "thumbnail"
        case description = "description"
    }
    
    func getAppearanceDescription() -> String {
        if let desc = description, !desc.isEmpty {
            return desc
        } else {
            return "(This item hasn't description)"
        }
    }
    
    func getImageUrl() -> String? {
        guard let path = self.thumbnail?.path, let ext = self.thumbnail?.thumbnailExtension else { return nil }
        return "\(path).\(ext)".replacingOccurrences(of: "http", with: "https")
    }
    
    func getDetailsUrl() -> URL? {
        var urlString = ""
        guard let urls = self.urls else { return nil }
        for url in urls {
            if (url.type == "detail") {
                urlString = url.url
            }
        }
        if (!urlString.isEmpty) {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
}

// MARK: - CharactersResponse
struct CharactersResponse: Codable {
    let offset, limit, total, count: Int
    let characters: [Character]
    
    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count
        case characters = "results"
    }
}

// MARK: - Result
struct Character: Codable {
    let id: Int
    let name, characterDescription: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: Comics
    let series: Series
    let stories: Stories
    let events: Events
    let urls: [URLElement]
    
    var imageUrl: String {
        return "\(self.thumbnail.path).\(self.thumbnail.thumbnailExtension)".replacingOccurrences(of: "http", with: "https")
    }
    
    func getDetailsUrl() -> URL? {
        var urlString = ""
        for url in urls {
            if (url.type == "detail") {
                urlString = url.url
            }
        }
        if (!urlString.isEmpty) {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case characterDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
    let returned: Int
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Series
struct Series: Codable {
    let available: Int
    let collectionURI: String
    let items: [SeriesItem]
    let returned: Int
}

// MARK: - SeriesItem
struct SeriesItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
    let type: String
}

// MARK: - Events
struct Events: Codable {
    let available: Int
    let collectionURI: String
    let items: [EventsItem]
    let returned: Int
}

// MARK: - EventsItem
struct EventsItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}

// MARK: - Story
struct Story: Codable {
    let id: Int
    let title: String
    let description: String?
    let urls: [URLElement]?
    let thumbnail: Thumbnail?

}
