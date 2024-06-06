//
//  SetBlitzViewModel.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI
import GameKit

class SetBlitzViewModel: BaseSetGame {
    @Published private var blitzGame: SetBlitz
    
    var timer: Timer?
    var isHost = false
    var remainingTime: Int {
        blitzGame.remainingTime
    }
    
    let match: GKMatch
    let localPlayer: GKLocalPlayer
    let communicationHelper: MatchCommunicationHelper
    
    var numOfMatchedPair: Int {
        cardsMatched.count / 3
    }
    
    var myScore: Int = 0 {
        willSet {
            if newValue > 0 {
                sendStrData(Msg.scoreMsg(newValue))
            }
        }
    }
    
    var opponentScore: Int = 0
    var opponentWin: Bool = false
    
    var isWinner: Bool {
        (myScore >= opponentScore) && !opponentWin
    }
    
    override var isOver: Bool {
        (blitzGame.isFinished || opponentWin) || _isOver
    }
    
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
        showPlayAgainInvitation = false
        if wantsToPlayAgain {
            sendStrData(Msg.PlayAgain.acceptInvitationMsg())
            reset()
        } else {
            sendStrData(Msg.PlayAgain.declineInvitationMsg())
        }
    }
    
    private func reset() {
        opponentWin = false
        myScore = 0
        opponentScore = 0
        blitzGame = SetBlitz()
        if isHost { initializeHost() }
        newGame()
    }
    
    init(_ match: GKMatch, localPlayer: GKLocalPlayer) {
        self.match = match
        self.localPlayer = localPlayer
        self.communicationHelper = MatchCommunicationHelper(match: match)
        self.blitzGame = SetBlitz()
        super.init()
        
        sendStrData(Msg.initialMsg(playerID: localPlayer.gamePlayerID))
    }
    
    private func initializeHost() {
        isHost = true
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [self] _ in
            blitzGame.countingDown()
            sendStrData(Msg.timerMsg())
            
            if remainingTime == 0 {
                finalizeGame()
            }
        }
    }
    
    private func finalizeGame() {
        if isWinner {
            sendStrData(Msg.finalMsg())
        }
        
        if isHost {
            timer?.invalidate()
        }
        
    }
    
    struct Msg {
        static let delimiter = "$$"
        
        static func initialMsg(playerID: String) -> String {
            MsgPrefix.initial.rawValue + delimiter + playerID
        }
        
        static func timerMsg() -> String {
            MsgPrefix.timer.rawValue + delimiter
        }
        
        static func scoreMsg(_ score: Int) -> String {
            MsgPrefix.score.rawValue + delimiter + String(score)
        }
        
        static func finalMsg() -> String {
            MsgPrefix.final.rawValue + delimiter
        }
        
        struct PlayAgain {
            static func inviteMsg() -> String {
                MsgPrefix.playAgain.rawValue + delimiter + "invite"
            }
            
            static func acceptInvitationMsg() -> String {
                MsgPrefix.playAgain.rawValue + delimiter + "true"
            }
            
            static func declineInvitationMsg() -> String {
                MsgPrefix.playAgain.rawValue + delimiter + "false"
            }
            
            struct Alert {
                static let title = "Rematch Invitation"
                static let message = "Do you want to play again?"
            }
        }
        
        static func decodeMsg(_ msg: String) -> (msgKind: MsgPrefix, content: String) {
            let msgSplit = msg.split(separator: delimiter)
           
            let msgPrefix = msgSplit.first
            let content = String(msgSplit.last?.replacing(delimiter, with: "") ?? "")
            
            print("msgPrefix: \(String(describing: msgPrefix)), content: \(content)")
            
            if let msgPrefix {
                switch msgPrefix {
                case MsgPrefix.timer.rawValue:
                    return (.timer, "")
                    
                case MsgPrefix.initial.rawValue:
                    return (.initial, content)
                
                case MsgPrefix.score.rawValue:
                    return (.score, content)
                
                case MsgPrefix.final.rawValue:
                    return (.final, "")
                    
                case MsgPrefix.playAgain.rawValue:
                    return (.playAgain, content)
                    
                default:
                    return (.error, "unidentified msgPrefix")
                }
            }
            
            return (.error, "Failed to proccess the msg: \(msg)")
        }
        
        enum MsgPrefix: String {
            case timer = "timer"
            case initial = "init"
            case score = "score"
            case final = "final"
            case playAgain = "playAgain"
            case error = "error"
        }
    }

}

extension SetBlitzViewModel: GKMatchDelegate {
    func sendStrData(_ msg: String) {
        communicationHelper.sendStrData(msg)
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let (msgType, content) = communicationHelper.decodeMsg(data)
        
        switch msgType {
        case .str:
            receivedStrDataHandler(content)
        case .default:
            print("Not String Data \(content)")
        }
    }
    
    func receivedStrDataHandler (_ msg: String) {
//        print(msg)
        let (msgPrefix, content) = Msg.decodeMsg(msg)
        
        switch msgPrefix {
        case .initial:
            if localPlayer.gamePlayerID < content {
                print("I am host \(localPlayer.displayName)")
                initializeHost()
            }
        case .timer:
            self.blitzGame.countingDown()
            
        case .score:
            self.opponentScore = Int(content)!
            
        case .final:
            self.opponentWin = true
            
        case .playAgain:
            print(content)
            if content == "invite" {
                showPlayAgainInvitation = true
            } else if content == "true" {
                // invitee accepted the invitation
                reset()
            } else {
                print("Invitee declined the invitaion")
            }
            
        default:
            print(content)
        }
        
    }
}
