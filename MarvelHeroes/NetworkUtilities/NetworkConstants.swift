//
//  NetworkConstants.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation

//Marvel API URL
let MarvelBaseURL = "https://gateway.marvel.com"

//API Keys Struct (public & private)
struct ApiKeys {
    static let publicKey = MarvelApiKeys.publicKey //Hidden file, change this value for your public Marvel API key
    static let privateKey = MarvelApiKeys.privateKey //Hidden file, change this value for your private Marvel API key
}

//Hash value converted to MD5.
let md5HashValue = "1\(ApiKeys.privateKey)\(ApiKeys.publicKey)".md5Value

//HTTPheaders enum with the needed headers
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

//ContenType enum for the needed content type params
enum ContentType: String {
    case json = "application/json"
}
