//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI
import GameKit
import GameKitUI

struct GameView: View {
    @StateObject var gameManager: GameManager
    
    var body: some View {
        viewState()
            .onAppear {
                gameManager.authenticate()
            }
            .sheet(isPresented: $gameManager.gameCenterHelper.showAuthentication) {
            authenticationView
        }
        .environmentObject(gameManager)
    }
    
    @ViewBuilder
    func viewState() -> some View {
        switch gameManager.status {
        case .initial, .authenticated:  MenuView()
            
        case .inGame: InGameViewT()
            
        case .gameOver: GameOverView()
        }
    }
    
    var authenticationView: some View {
        GKAuthenticationView { error in
            gameManager.gameCenterHelper.authenticationfailed(error: error)
        } authenticated: { player in
            gameManager.gameCenterHelper.authenticationSucceeded(player: player)
        }
        .frame(width: 640, height: 480)
    }

}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView(gameManager: GameManager())
//    }
//}
//


