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
    @State var showMatchMakingView = false
    
    var body: some View {
        VStack {
            Button() {
                gameManager.startGame(.setPractice)
            } label: {
                Text("Practice")
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button() {
                gameManager.startGame(.setBlitz)
            } label: {
                Text("SET BLITZ")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .sheet(
            isPresented: $gameManager.findNewMatch,
            content: { matchMakingView }
        )
    }
    
    var matchMakingView: some View {
        MatchMakingView()
    }
}

#Preview {
    GameModeChoosingView()
}
