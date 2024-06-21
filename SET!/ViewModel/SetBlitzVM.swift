//
//  SetBlitzViewModel.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI
import GameKit
import OrderedCollections

class SetBlitzVM: BaseSetGameVM {
    @Published var blitzGame: SetBlitz
    @Published private(set) var isFinished: Bool = false
    
    var timer: Timer?
    var isHost = false
    var remainingTime: Int { blitzGame.remainingTime }
    
    let match: GKMatch
    let id: String
    let localPlayer: GKLocalPlayer
    let communicationHelper: MatchCommunicationHelper
    
    var numOfMatchedPair: Int { cardsMatched.count / 3 }
    
    var myScore: Int = 0 {
        willSet {
            if newValue > 0 {
                sendStrData(Msg.scoreMsg(newValue, playerID: id))
            }
        }
    }
    
    var remotePlayers: OrderedDictionary<String, SetBlitz.Player> = [:]
    var opponentWin: Bool {
        // value.win will only be set when someone has matched all the cards before time is up
        remotePlayers.values.filter({$0.win}).count > 0
    }
        
    var isWinner: Bool {
        myScore >= remotePlayers.values.map({$0.score}).max()! && !opponentWin
    }
    
    // Conditions of game over
    // 1. Time up
    // 2. Someone has matched all the cards before time is up
    // 3. Local player has matched all the cards before time is up
    override var isOver: Bool { blitzGame.isFinished || opponentWin || setGame.isFinished }
    
    
    // MARK: Intent
    override func choose(_ card: Card) {
        _choose(card)
        
        if numOfMatchedPair > myScore {
            myScore += 1
            
            if isOver {
                finalizeGame()
            }
        }
    }
    
    @Published var showPlayAgainInvitation = false
    func inviteToPlayAgain() {
        sendStrData(Msg.PlayAgain.inviteMsg())
    }
    
    func processPlayAgainInvitation(wantsToPlayAgain: Bool) {
        if wantsToPlayAgain {
            sendStrData(Msg.PlayAgain.acceptInvitationMsg())
            reset()
        } else {
            sendStrData(Msg.PlayAgain.declineInvitationMsg())
        }
    }
    
    func reset() {
        myScore = 0
        isHost = false
        isFinished = false
        remotePlayers = [:]
        blitzGame = SetBlitz()
        sendStrData(Msg.initialMsg(playerID: localPlayer.gamePlayerID))
        if isHost { initializeHost() }
    }
    
    init(_ match: GKMatch, localPlayer: GKLocalPlayer, developerMode: Bool) {
        self.match = match
        self.localPlayer = localPlayer
        self.id = localPlayer.gamePlayerID
        self.communicationHelper = MatchCommunicationHelper(match: match)
        self.blitzGame = SetBlitz()
        self.developerMode = developerMode
        self.abilityNumber = developerMode ? 100 : 3
        super.init()
        
        sendStrData(Msg.initialMsg(playerID: id))
    }
    
    func initializeHost() {
        isHost = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            blitzGame.countingDown()
            sendStrData(Msg.timerMsg(playerID: id))
            
            if remainingTime == 0 {
                finalizeGame()
            }
        }
    }
    
    func finalizeGame() {
        if isHost {
            timer?.invalidate()
        }
        
        if isWinner && remainingTime > 0 || isHost && remainingTime == 0 {
            sendStrData(Msg.finalMsg(playerID: id))
        }
        
        GameCenterHelper.default.recordGameResult(won: isWinner, score: myScore)
        isFinished = true
    }
    
    // MARK: Ability Section
    @Published var abilityNumber: Int
    override func hint() {
        super.hint()
        
        guard cardsSelected.count == 3 else { return }
        abilityNumber -= 1
    }
    
    func abilityShuffle() {
        sendStrData(Msg.Ability.shuffleMsg(playerID: id))
        abilityNumber -= 1
    }
    
    func getShuffled() {
        _shuffle()
    }
    
    let developerMode: Bool
}

extension SetBlitz {
    struct Player {
        let playerInstance: GKPlayer
        var win = false
        var score: Int = 0
        
        init(_ playerInstance: GKPlayer) {
            self.playerInstance = playerInstance
        }
    }
    
}
