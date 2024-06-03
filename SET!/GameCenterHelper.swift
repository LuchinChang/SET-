//
//  GameCenterHelper.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import Foundation
import GameKit


struct GameCenterHelper {
    private var authenticationHelper = AuthenticationViewModel()
    private var matchMakingHelper = MatchMakingViewModel()
    
    var showAuthentication = false
    var showMatchMaking = false
    var showAlert = false
    
    var localPlayer: GKPlayer?
    var remotePlayer: [GKPlayer]?
    var match: GKMatch?
    
    
    mutating func authenticationSucceeded(player: GKPlayer) {
        localPlayer = player
        showAuthentication = false
    }
    
    mutating func authenticationfailed(error: Error) {
        print("Authentication Failed: \(error)")
        showAuthentication = false
    }
    
    mutating func matchCancelled() {
        print("Player Cancelled")
        showMatchMaking = false
    }
    
    func getMatchRequest(minPlayers: Int = 2, MaxPlayers: Int = 2, InviteMsg: String = "Let's Play") -> GKMatchRequest {
        let request = GKMatchRequest()
        
        request.minPlayers = minPlayers
        request.maxPlayers = MaxPlayers
        request.inviteMessage = InviteMsg
        
        return request
    }
    
    mutating func matchFailed(error: Error) {
        print("Match Making Failed: \(error)")
        showMatchMaking = false
    }
    
    mutating func matchSucceeded(newMatch: GKMatch) {
        showMatchMaking = false
        match = newMatch
        remotePlayer = match?.players
        print("\(match.debugDescription)")
    }
    
    mutating func authenticate() {
        showAuthentication = true
    }
    
    mutating func findAMatch() {
        showMatchMaking = true
    }
}
