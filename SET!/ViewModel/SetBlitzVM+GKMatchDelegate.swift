//
//  SetBlitzVM+GKMatchDelegate.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/19.
//

import Foundation
import GameKit

extension SetBlitzVM: GKMatchDelegate {
    func sendStrData(_ msg: String) {
        communicationHelper.sendStrData(msg)
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let (msgType, content) = communicationHelper.decodeMsg(data)
        
        switch msgType {
        case .str:
            receivedStrDataHandler(content)
        case .default:
            DebugHelper.printInfo("Not String Data \(content)")
        }
    }
    
    func receivedStrDataHandler (_ msg: String) {
        let (msgPrefix, senderId, content) = Msg.decodeMsg(msg)
        
        switch msgPrefix {
        case .initial:
            remotePlayers[senderId] = .init(match.players.filter({ $0.gamePlayerID == senderId }).first!)
            
            if remotePlayers.count == match.players.count {
                if localPlayer.gamePlayerID < remotePlayers.keys.min()! {
                    DebugHelper.printInfo("I am host \(localPlayer.displayName)")
                    initializeHost()
                }
            }
            
        case .timer:
            self.blitzGame.countingDown()
            
        case .score:
            if let score = Int(content) {
                remotePlayers[senderId]?.score = score
            }
            
        case .final:
            if remainingTime > 0 { remotePlayers[senderId]?.win = true }
            finalizeGame()
            
        case .playAgain:
            DebugHelper.printInfo(content)
            if content == "invite" {
                showPlayAgainInvitation = true
                
            } else if content == "true" {
                // invitee accepted the invitation
                reset()
                   
            } else {
                DebugHelper.printInfo("Invitee declined the invitaion")
            }
        
        case .ability:
            switch Msg.Ability(rawValue: content) {
            case .shuffle:
               getShuffled()
            default:
                DebugHelper.printInfo(content)
            }
            
        default:
            DebugHelper.printInfo(content)
        }
    }
    
    enum Msg {
        static let delimiter = "$$"
        static let emptyMsg = " "
        
        static func initialMsg(playerID: String) -> String {
            MsgPrefix.initial.rawValue + delimiter + playerID + delimiter + emptyMsg
        }
        
        static func timerMsg(playerID: String) -> String {
            MsgPrefix.timer.rawValue + delimiter + playerID + delimiter + emptyMsg
        }
        
        static func scoreMsg(_ score: Int, playerID: String) -> String {
            MsgPrefix.score.rawValue + delimiter + playerID + delimiter + String(score)
        }
        
        static func finalMsg(playerID: String) -> String {
            MsgPrefix.final.rawValue + delimiter + playerID + delimiter + emptyMsg
        }
        
        enum Ability: String {
            case shuffle = "shuffle"
            
            static func shuffleMsg(playerID: String) -> String {
                MsgPrefix.ability.rawValue + delimiter + playerID + delimiter + Ability.shuffle.rawValue
            }
        }
        
        enum PlayAgain {
            static func inviteMsg() -> String {
                MsgPrefix.playAgain.rawValue + delimiter + "invite"
            }
            
            static func acceptInvitationMsg() -> String {
                MsgPrefix.playAgain.rawValue + delimiter + "true"
            }
            
            static func declineInvitationMsg() -> String {
                MsgPrefix.playAgain.rawValue + delimiter + "false"
            }
            
            enum Alert {
                static let title = "Rematch Invitation"
                static let message = "Do you want to play again?"
            }
        }
        
        static func decodeMsg(_ msg: String) -> (msgKind: MsgPrefix, senderId: String, content: String) {
            let msgSplit = msg.split(separator: delimiter)
            
            let msgPrefix = msgSplit.first
            let senderId = String(msgSplit[1])
            let content = String(msgSplit.last?.replacing(delimiter, with: "") ?? "")
           
            if let msgKind = MsgPrefix(rawValue: String(msgPrefix ?? "")) {
                return (msgKind, senderId, content)

            } else {
                return (.error, "", "")
            }
            
        }
        
        enum MsgPrefix: String {
            case timer = "timer"
            case initial = "init"
            case score = "score"
            case final = "final"
            case ability = "ability"
            case playAgain = "playAgain"
            case error = "error"
        }
    }
}
