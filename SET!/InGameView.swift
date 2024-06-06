//
//  InGameViewT.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI

struct InGameView: View {
    @EnvironmentObject var gameManager: GameManager
    
    @State var adCoordinator = AdCoordinator()
    
    var body: some View {
        VStack {
            switch gameManager.gameMode {
            case .setPractice:
                PracticeSetGameView(gameManager.gameModeManager as! ShapeSetGame)
            case .setBlitz:
                BlitzSetGameView(gameManager.gameModeManager as! SetBlitzViewModel)
            default:
                Text("You are in the game View")
            }
        }
        .onAppear {
            adCoordinator.loadAd()
        }
        .environmentObject(adCoordinator)
    }
        
}

#Preview {
    InGameView()
}
