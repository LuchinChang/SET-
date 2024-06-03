//
//  GameManager.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import Foundation
import SwiftUI
import GameKit


class GameManager: NSObject, ObservableObject {
    @Published var gameCenterHelper = GameCenterHelper()
    
    @Published var status: GameStatus = .initial
    @Published var gameModeManager: (any SetGameModeViewModel)?
    var gameMode: GameMode?
    var isAuthenticated: Bool?
    var match: GKMatch? {
        gameCenterHelper.match
    }
    
 
    private func getGameModeManager() -> any SetGameModeViewModel {
        
        let manager: any SetGameModeViewModel = switch gameMode {
        case .setPractice: ShapeSetGame()
        case .setBlitz: SetBlitzViewModel(match: match!)
        default: ShapeSetGame()
        }
        
        return manager
    }

    
    // MARK: Intentions
    func authenticate() {
        gameCenterHelper.authenticate()
        status = .authenticated
    }

    func startGame(_ gameMode: GameMode) {       
        self.gameMode = gameMode

        if gameMode != .setPractice {
            gameCenterHelper.findAMatch()
        } else {
            initializeGame()
        }
    }
    
    func initializeGame() {
        print("I am initing")
        gameModeManager = getGameModeManager()
        status = .inGame
    }
    
}

enum GameMode {
    case setPractice
    case setBlitz
}

enum GameStatus {
    case initial
    case authenticated
    case inGame
    case gameOver
}
