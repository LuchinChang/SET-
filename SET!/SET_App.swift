//
//  SET_App.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {
    var adIsInitialized = false
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "7004e00e80a35068870b1a5842633a32", "5d9f2826c99b7d74097d0a88395f6ed6" ]
        
        GADMobileAds.sharedInstance().start(completionHandler: { _ in
            self.adIsInitialized = true
        })
        return true
    }
}


@main
struct SET_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(gameManager: GameManager())
        }
    }
}
