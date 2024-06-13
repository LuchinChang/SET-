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
    @StateObject private var gameManager: GameManager = .init()
    @State private var showAds = true
    @State private var showTurnOffAdOption = false
    
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
                
                if showAds {
                    bannerAd.frame(maxHeight: geo.size.height / 12)
                }
            }
            .alert("Turn off Ads?", isPresented: $showTurnOffAdOption) {
                Button("Yes") {
                    showAds = false
                }
                
                Button("No") {
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    var bannerAd: some View {
        BannerAdView()
            .onLongPressGesture {
                showTurnOffAdOption = true
            }
    }
}
