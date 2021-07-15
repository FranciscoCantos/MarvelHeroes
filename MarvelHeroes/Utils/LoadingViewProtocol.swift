//
//  LoadingViewProtocol.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation


/// Protocol needed to make views show a loading view while downloads data form API
protocol LoadingViewProtocol {
    func configureLoadingView()
    func startLoading()
    func stopLoading()
}
