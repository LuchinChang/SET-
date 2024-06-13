//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI
import GameKit
import GameKitUI

struct ContentView: View {
    @StateObject var gameManager: GameManager
    
    var body: some View {
        VStack {
            Group {
                switch gameManager.status {
                case .initial: authenticationView
                case .menu: MenuView()
                case .inGame: InGameView()
                }
            }
            .environmentObject(gameManager)
            bannerAd
        }
    }
    
    var authenticationView: some View {
        AuthenticationView().frame(width: 640, height: 480)
    }
    
    var bannerAd: some View {
        AdBannerView().frame(maxHeight: 60)
    }
}
