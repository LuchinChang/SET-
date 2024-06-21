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
    
    let gameCenterHelper = GameCenterHelper.default
    
    var localPlayer: GKLocalPlayer? {
        gameCenterHelper.localPlayer
    }
    var match: GKMatch? {
        gameCenterHelper.match
    }
    
    var developerMode = false
    @Published var showDeveloperModeMsg = false
    
    // MARK: Intentions
    func startGame(_ gameMode: GameMode) {
        self.gameMode = gameMode
     
        if GameMode.multiPlayerGame.contains(gameMode) {
            findNewMatch = true
        } else {
            initializeGame()
        }
    }
    
    func getPracticeSetGameVM() -> SetPracticeVM {
        SetPracticeVM()
    }
    
    func getBlitzzSetGameVM() -> SetBlitzVM {
        let blitzSetGame = SetBlitzVM(match!, localPlayer: localPlayer!, developerMode: developerMode)
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
        
        GameCenterHelper.default.matchSucceededHandler = { [self] in
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

extension GameManager {
    func toggleDeveloperMode() {
        developerMode.toggle()
        showDeveloperModeMsg = true
    }
}

