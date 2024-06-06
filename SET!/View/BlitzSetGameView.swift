//
//  SetBlitzGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/1.
//

import SwiftUI

struct BlitzSetGameView: View {
    @ObservedObject var blitzSetGame: SetBlitzViewModel
    
    var body: some View {
        Group {
            if blitzSetGame.isOver {
                BlitzSetGameOverView().onTapGesture { blitzSetGame.newGame() }
            } else {
                BlitzSetGameInGameView()
            }
        }
        .environmentObject(blitzSetGame)
    }
    
    init(_ blitzSetGame: SetBlitzViewModel) {
        self.blitzSetGame = blitzSetGame
        blitzSetGame.newGame()
    }
}
