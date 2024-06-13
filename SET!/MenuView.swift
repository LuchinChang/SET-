//
//  MenuView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI
import GameKitUI
import AdSupport

struct MenuView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                PlayerProfileView.localPlayer
                Spacer()
                NavigationLink(destination: GKGameCenterView()) {
                    Text("LeaderBoard")
                }
                NavigationLink(destination: GameModeChoosingView()) {
                    Text("Start Game!")
                }
//                NavigationLink(destination: RewardedInterstitialContentView()) {
//                    Text("Gain Reward")
//                }
            }
            .padding()
            .environmentObject(gameManager)
            .buttonStyle(ButtonViewStyle.Primary())
            
        }
    }
}

#Preview {
    MenuView()
        .environmentObject(GameManager())
}
