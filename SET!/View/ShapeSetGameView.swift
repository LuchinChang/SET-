//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject var shapeSetGame: ShapeSetGame
    
    var body: some View {
        Group {
            if shapeSetGame.isOver {
                GameOverView().onTapGesture { shapeSetGame.newGame() }
            } else {
                InGameView()
                    .environmentObject(shapeSetGame)
            }
        }
    }
    
    init(_ shapeSetGame: ShapeSetGame) {
        self.shapeSetGame = shapeSetGame
        shapeSetGame.newGame()
    }
}

extension ShapeSetGame {
    func dealWithAnimation(_ numOfCards: Int) {
        
        var delay: TimeInterval = 0
        for _ in 0..<numOfCards {
            withAnimation(.easeInOut(duration: 1).delay(delay)) {
                deal(1)
            }
            delay += 0.2
        }
    }
    
    func newGame() {
        _newGame()
        dealWithAnimation(12)
    }
}
