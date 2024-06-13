//
//  GameCenterHelper.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import Foundation
import GameKit

class GameCenterHelper {
    var showAlert = false
    
    var localPlayer: GKPlayer?
    var remotePlayer: [GKPlayer]?
//    var matchMakingMode: 
    var match: GKMatch?
    var matchSucceededHandler: () -> Void = {}
    var authenticationSucceededHandler: () -> Void = {}
    
    
    func authenticationSucceeded(player: GKPlayer) {
        localPlayer = player
        authenticationSucceededHandler()
    }
    
    func authenticationfailed(error: Error) {
        print("Authentication Failed: \(error)")
    }
    
    func matchCancelled() {
        print("Player Cancelled")
    }
    
    func getMatchRequest(minPlayers: Int = 2, MaxPlayers: Int = 2, InviteMsg: String = "Let's Play") -> GKMatchRequest {
        let request = GKMatchRequest()
        
        request.minPlayers = minPlayers
        request.maxPlayers = MaxPlayers
        request.inviteMessage = InviteMsg
        
        return request
    }
    
    func matchFailed(error: Error) {
        print("Match Making Failed: \(error)")
    }
    
    func matchSucceeded(newMatch: GKMatch) {
        match = newMatch
        remotePlayer = match?.players
        matchSucceededHandler()
    }
    
    static let defaultHelper = GameCenterHelper()
}
