//
//  SetBlitz.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/30.
//

import Foundation

struct SetBlitz: MultiPlayer, TimedGame {
    var isFinished: Bool {
        remainingTime == 0
    }
    
    var remainingTime = Constants.maxRemainingTime
    
    mutating func countingDown() {
        remainingTime -= 1
    }
    
    private struct Constants {
        static let maxRemainingTime = 60 // seconds
    }
}
