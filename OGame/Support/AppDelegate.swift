//
//  AppDelegate.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let debugMode = UserDefaults.standard.object(forKey: "debugMode") as? Bool {
            UserDefaults.standard.set(debugMode, forKey: "debugMode")
        } else {
            UserDefaults.standard.set(false, forKey: "debugMode")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
