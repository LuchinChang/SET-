//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct PracticeSetGameView: View {
    @ObservedObject var shapeSetGame: ShapeSetGame
    
    var body: some View {
        Group {
            if shapeSetGame.isOver {
                PractiveSetGameOverView().onTapGesture { shapeSetGame.newGame() }
            } else {
                PracticeSetGameInGameView()
                    .environmentObject(shapeSetGame)
            }
        }
    }
    
    init(_ shapeSetGame: ShapeSetGame) {
        self.shapeSetGame = shapeSetGame
        shapeSetGame.newGame()
    }
}
