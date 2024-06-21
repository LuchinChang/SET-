//
//  SetBltizGameCenter.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/17.
//

import Foundation

enum SetBlitzGameCenter {
    enum LeaderBoard: String, CaseIterable {
        case mostWins = "lcchang.taiwan.SET.wins"
        case highestScore = "lcchang.taiwan.SET.leaderboard.HighestScore"
        
        static let ids = allCases.map { $0.rawValue }
    }
    
    enum Achievement: String, CaseIterable {
        case firstWin = "lcchang.taiwan.SET.FirstWin"
        case highestScore = "lcchang.taiwan.SET.achievement.HighestScore"
        
        static let ids = allCases.map { $0.rawValue }
    }
}

struct PlayerRecord: Codable {
    private(set) var numberOfWins: Int
    private(set) var winStreaks: Int
    private(set) var higestScore: Int
    
    mutating func addGameRecord(won: Bool, score: Int) {
        if won {
            numberOfWins += 1
            winStreaks += 1
        } else {
            winStreaks = 0
        }
        
        higestScore = max(score, higestScore)
    }
    
    static let `default` = PlayerRecord(numberOfWins: 0, winStreaks: 0, higestScore: 0)
    static let placeHolder = PlayerRecord(numberOfWins: 0, winStreaks: 0, higestScore: 0)
}
