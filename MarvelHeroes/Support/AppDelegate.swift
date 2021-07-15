//
//  AppDelegate.swift
//  MarvelCharacters
//
//  Created by Francisco Cantos on 30/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }
    
    private func configureWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let rootVC = window?.rootViewController
        let router = MainRouter(rootViewController: rootVC)
        window?.rootViewController = router.getRootViewController()
    }
}
