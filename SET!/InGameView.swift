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
                PracticeSetGameView(gameManager: gameManager)
            case .setBlitz:
                BlitzSetGameView(gameManager: gameManager)
            case .none:
                Text("There are problems setting up your game!")
            }
        }
        .onAppear {
            adCoordinator.loadAd()
        }
        .environmentObject(gameManager)
        .environmentObject(adCoordinator)
    }
        
}
