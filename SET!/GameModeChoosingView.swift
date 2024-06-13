//
//  GameModeChoosingView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI
import GameKitUI

struct GameModeChoosingView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        VStack {
            Button("Practice") {
                gameManager.startGame(.setPractice)
            }
            
            Button("SET BLITZ") {
                gameManager.startGame(.setBlitz)
            }
        }
        .padding()
        .environmentObject(gameManager)
        .buttonStyle(ButtonViewStyle.Primary())
        .sheet(isPresented: $gameManager.findNewMatch) {
            matchMakingView
        }
        
    }
    
    var matchMakingView: some View {
        MatchMakingView()
    }
}

#Preview {
    GameModeChoosingView()
}
