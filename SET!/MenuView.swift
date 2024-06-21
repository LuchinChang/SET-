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
                playerProfile
                Spacer()
                NavigationLink(destination: GKDashboardViewController()) {
                    Text("DashBoard")
                }
                
                NavigationLink(destination: GameModeChoosingView()) {
                    Text("Start!")
                }
            }
            .padding()
            .environmentObject(gameManager)
            .buttonStyle(ButtonViewStyle.primary)
            .alert("Developer Mode is \(gameManager.developerMode ? "on" : "off")", 
                   isPresented: $gameManager.showDeveloperModeMsg) {
                Button("Ok", action: {})
            }
        }
    }
    
    var playerProfile: some View {
        PlayerProfileView(gameManager.localPlayer!, hideName: false)
            .onLongPressGesture() {
                gameManager.toggleDeveloperMode()
            }
    }
}

#Preview {
    MenuView()
        .environmentObject(GameManager())
}
