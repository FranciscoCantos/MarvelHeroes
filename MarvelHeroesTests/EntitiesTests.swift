//
//  EntitiesTests.swift
//  MarvelHeroes
//
//  Created by Kurro on 14/7/21.
//

import XCTest
@testable import MarvelHeroes

class EntityTests: XCTestCase {

    func testAppearanceSetGet() {
        let urlElement = URLElement(type: "detail", url: "www.google.com")
        let urlElement2 = URLElement(type: "wiki", url: "www.google.com")
        let thumnail = Thumbnail(path: "thumbnailPath", thumbnailExtension: "thumbnailExtension")

        let appearance = Appearance(id: 25,
                                    title: "appearanceTitle",
                                    description: "appearanceTitle",
                                    urls: [urlElement, urlElement2],
                                    thumbnail: thumnail)
        
        XCTAssertEqual(appearance.getImageUrl(), "\(thumnail.path).\(thumnail.thumbnailExtension)")
        XCTAssertEqual(appearance.getDetailsUrl(), URL(string: urlElement.url))
        XCTAssertEqual(appearance.getAppearanceDescription(), appearance.description)
    }
    
    func testAppearanceSetGetFail() {
        let urlElement = URLElement(type: "wiki", url: "")
        let thumnail = Thumbnail(path: "thumbnailPath", thumbnailExtension: "thumbnailExtension")

        let appearance = Appearance(id: 25,
                                    title: "appearanceTitle",
                                    description: nil,
                                    urls: [urlElement],
                                    thumbnail: thumnail)
        
        XCTAssertEqual(appearance.getDetailsUrl(), nil)
        XCTAssertEqual(appearance.getAppearanceDescription(), "(This item hasn't description)")
    }
    
    func testCharacterSetGet() {
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
        
        let character = Character(id: 25, name: "characterName",
                                  characterDescription: "characterName",
                                  thumbnail: thumnail,
                                  resourceURI: "characterName",
                                  comics: comics,
                                  series: series,
                                  stories: stories,
                                  events: events,
                                  urls: [urlElement])
        
        XCTAssertEqual(character.getDetailsUrl(), URL(string: urlElement.url))
        XCTAssertEqual(character.imageUrl, "\(thumnail.path).\(thumnail.thumbnailExtension)")
    }
}
