//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct PracticeSetGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @StateObject private var shapeSetGame: ShapeSetGame
    
    var body: some View {
        Group {
            if shapeSetGame.isOver {
                PractiveSetGameOverView()
            } else {
                PracticeSetGameInGameView()
            }
        }
        .environmentObject(shapeSetGame)
    }
    
    init(gameManager: GameManager) {
        _shapeSetGame = StateObject(wrappedValue: gameManager.getPracticeSetGameVM())
    }
}
