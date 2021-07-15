//
//  APIConfiguration.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import Alamofire

//Protocool used for the network configuration. 
protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
}
