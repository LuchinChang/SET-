//
//  GameCenterHelper.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import Foundation
import GameKit

class BaseGameCenterHelper {
    var showAlert = false
    
    var isAuthenticated = false
    var localPlayer: GKLocalPlayer? { GKLocalPlayer.local }
    
    var match: GKMatch?
    var remotePlayer: [GKPlayer]? { match?.players }
    
    var authenticationSucceededHandler: () -> Void = {}
    var matchSucceededHandler: () -> Void = {}
    
    // MARK: Authentication
    func authenticationSucceeded(player: GKPlayer) {
        isAuthenticated = true
        authenticationSucceededHandler()
    }
    
    func authenticationfailed(error: Error) {
        print("Authentication Failed: \(error)")
    }
    
    // MARK: MatchMaking
    func matchCancelled() {
        print("Player Cancelled")
    }
    
    func getMatchRequest(minPlayers: Int = 2, MaxPlayers: Int = 4, InviteMsg: String = "Let's Play") -> GKMatchRequest {
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
        matchSucceededHandler()
    }
}


class GameCenterHelper: BaseGameCenterHelper {
    private var leaderboards = [SetBlitzGameCenter.LeaderBoard:GKLeaderboard]()
    private let playerRecord = PlayerRecordVM()
    
    // MARK: Intent
    func recordGameResult(won: Bool, score: Int) {
        print(won, score)
        
        let oldHighestScore = playerRecord.highestScore
        
        playerRecord.addGameRecord(won: won, score: score)
        
        if won {
            submitRecord(to: .mostWins, score: playerRecord.numOfWins)
            
//            if playerRecord.numOfWins == 1 {
//                reportAchievement(to: .firstWin)
//            }
        }
        
        if oldHighestScore < playerRecord.highestScore {
            submitRecord(to: .highestScore, score: score)
//            reportAchievement(to: .highestScore)
        }
        
    }
    
    
    override func authenticationSucceeded(player: GKPlayer) {
        loadLeaderboards()
        
        Task {
            do {
                try await playerRecord.loadRecord()
                print(playerRecord)
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        super.authenticationSucceeded(player: player)
    }
    
    // MARK: Leaderboard & Achievements
    private func loadLeaderboards() {
        GKLeaderboard.loadLeaderboards(IDs: SetBlitzGameCenter.LeaderBoard.ids) { leaderboards, err in
            guard err == nil else {
                print(err.debugDescription)
                return
            }
            
            if let leaderboards {
                for (name, leaderboard) in zip(SetBlitzGameCenter.LeaderBoard.allCases, leaderboards) {
                    self.leaderboards[name] = leaderboard
                }
            }
        }
    }
    
    private func loadAchievements(_ name: SetBlitzGameCenter.Achievement) -> GKAchievement {
        return .init(identifier: name.rawValue, player: localPlayer!)
    }
    
    private func submitRecord(to name: SetBlitzGameCenter.LeaderBoard, score: Int) {
        guard let leaderboard = leaderboards[name] else { return }
        
        leaderboard.submitScore(score, context: score, player: localPlayer!) { err in
            print(err.debugDescription)
        }
    }
    
    private func reportAchievement(to name: SetBlitzGameCenter.Achievement) {
        let achievement = loadAchievements(name)
        
        print("Reporting Achievement", name)
        
        switch name {
        default:
            achievement.percentComplete = 100
        }
        
        Task {
            do {
                try await GKAchievement.report([achievement])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static let `default` = GameCenterHelper()
}

class PlayerRecordVM {
    private var record = PlayerRecord.placeHolder
    private var localPlayer: GKLocalPlayer? { GameCenterHelper.default.localPlayer }
    
    private let recordEncoder = JSONEncoder()
    private let recordDecoder = JSONDecoder()
    
    var numOfWins: Int { record.numberOfWins }
    var highestScore: Int { record.higestScore }
    
    func addGameRecord(won: Bool, score: Int) {
        record.addGameRecord(won: won, score: score)
        Task {
            await saveRecord()
        }
    }
    
    func loadRecord() async throws {
        let records = try await localPlayer!.fetchSavedGames()
        
        if let recordData = records.filter({ $0.name == PlayerRecordVM.recordFile }).first {
            record = try await recordDecoder.decode(PlayerRecord.self, from: recordData.loadData())
            print("Loading Player Record Success", record.numberOfWins, record.higestScore)
            
        } else {
            print("Using Default")
            record = .default
        }
    }
    
    private func saveRecord() async {
        do {
            let recordData = try recordEncoder.encode(record)
            try await localPlayer!.saveGameData(recordData, withName: PlayerRecordVM.recordFile)
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private static let recordFile = "PlayerRecord"
}
