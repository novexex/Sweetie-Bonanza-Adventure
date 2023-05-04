//
//  AppDelegate.swift
//  Sweetie Bonanza Adventure
//
//  Created by Artour Ilyasov on 03.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = GameViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let viewController = window?.rootViewController else { return }
        if let gameController = viewController as? GameViewController {
            gameController.saveGameSetup()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        applicationDidEnterBackground(application)
    }
}
