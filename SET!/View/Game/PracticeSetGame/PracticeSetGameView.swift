//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct PracticeSetGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @StateObject private var practiceSetGame: SetPracticeVM
    
    var body: some View {
        Group {
            if practiceSetGame.isOver {
                PractiveSetGameOverView()
            } else {
                PracticeSetGameInGameView()
            }
        }
        .environmentObject(practiceSetGame)
    }
    
    init(gameManager: GameManager) {
        _practiceSetGame = StateObject(wrappedValue: gameManager.getPracticeSetGameVM())
    }
}
