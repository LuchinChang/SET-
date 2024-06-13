//
//  GameManager.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import Foundation
import SwiftUI
import GameKit

class GameManager: ObservableObject {
    @Published private(set) var status: GameStatus = .initial
    @Published var isAuthenticated = false

    @Published private(set) var gameMode: GameMode?
    
    
    @Published var findNewMatch = false
    
    let gameCenterHelper = GameCenterHelper.defaultHelper
    
    var localPlayer: GKLocalPlayer? {
        gameCenterHelper.localPlayer as? GKLocalPlayer
    }
    var match: GKMatch? {
        gameCenterHelper.match
    }
 

    // MARK: Intentions
    func startGame(_ gameMode: GameMode) {
        self.gameMode = gameMode
     
        if GameMode.multiPlayerGame.contains(gameMode) {
            findNewMatch = true
        } else {
            initializeGame()
        }
    }
    
    func getPracticeSetGameVM() -> ShapeSetGame {
        ShapeSetGame()
    }
    
    func getBlitzzSetGameVM() -> SetBlitzViewModel {
        let blitzSetGame = SetBlitzViewModel(match!, localPlayer: localPlayer!)
        match?.delegate = blitzSetGame
        return blitzSetGame
    }
    
    func initializeGame() {
        status = .inGame
    }
    
    func finishGame() {
        status = .menu
    }
    
    init() {
        gameCenterHelper.authenticationSucceededHandler = {
            self.status = .menu
        }
        
        GameCenterHelper.defaultHelper.matchSucceededHandler = { [self] in
            initializeGame()
        }
    }
    
    enum GameMode {
        case setPractice
        case setBlitz
        
        static let multiPlayerGame = Set([GameMode.setBlitz])
    }
    
    enum GameStatus {
        case initial
        case menu
        case inGame
    }
}

