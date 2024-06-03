//
//  InGameViewT.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI

struct InGameViewT: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        switch gameManager.gameMode {
        case .setPractice:
            ShapeSetGameView(gameManager.gameModeManager as! ShapeSetGame)
        case .setBlitz:
            
            SetBlitzGameView(gameManager.gameModeManager as! SetBlitzViewModel)
        default:
            Text("You are in the game View")
        }
    }
}

#Preview {
    InGameViewT()
}
