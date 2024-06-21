//
//  SetBlitzGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/1.
//

import SwiftUI

struct BlitzSetGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @StateObject private var blitzSetGame: SetBlitzVM
    
    var body: some View {
        Group {
            if blitzSetGame.isFinished {
                BlitzSetGameOverView()
            } else {
                BlitzSetGameInGameView()
            }
        }
        .environmentObject(blitzSetGame)
    }
    
    init(gameManager: GameManager) {
        _blitzSetGame = StateObject(wrappedValue: gameManager.getBlitzzSetGameVM())
    }
}
