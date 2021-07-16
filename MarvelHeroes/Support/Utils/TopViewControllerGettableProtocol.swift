//
//  TopViewControllerGettableProtocol.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import UIKit

protocol TopViewControllerGettableProtocol {
    var topViewController: UIViewController? { get }
    var topNavController: UINavigationController? { get }
}

extension TopViewControllerGettableProtocol {
    var topViewController: UIViewController? {
        return UIApplication.shared.topViewController
    }
    
    var topNavController: UINavigationController? {
        return UIApplication.shared.topViewController as? UINavigationController
    }
}
