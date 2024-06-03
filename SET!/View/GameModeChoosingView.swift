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
        .sheet(isPresented: $gameManager.gameCenterHelper.showMatchMaking) {
            matchMakingView
        }
    }
    
    var matchMakingView: some View {
        GKMatchmakerView(
            matchRequest: gameManager.gameCenterHelper.getMatchRequest(),
            canceled: { gameManager.gameCenterHelper.matchCancelled() },
            failed: { error in gameManager.gameCenterHelper.matchFailed(error: error) },
            started: { match in
                gameManager.gameCenterHelper.matchSucceeded(newMatch: match)
                gameManager.initializeGame()
            }
        )
    }
}

#Preview {
    GameModeChoosingView()
}
