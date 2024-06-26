//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI
import GameKit

struct ContentView: View {
    @StateObject private var gameManager: GameManager = .init()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Group {
                    switch gameManager.status {
                    case .initial: AuthenticationView()
                    case .menu: MenuView()
                    case .inGame: InGameView()
                    }
                }
                .environmentObject(gameManager)
                
                if !gameManager.developerMode {
                    bannerAd.frame(maxHeight: geo.size.height / 12)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    var bannerAd: some View {
        BannerAdView()
            .disabled(gameManager.status == .inGame)
    }
}
