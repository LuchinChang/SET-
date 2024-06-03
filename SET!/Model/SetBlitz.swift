//
//  SetBlitz.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/30.
//

import Foundation

struct SetBlitz: MultiPlayer {
    var minPlayer = 2
    var maxPlayer = 2
    
   
    var inGame = false
    var isFinished = false
    var setGame = SetGame()
    var remainingTime = Constants.maxRemainingTime
    
    
    
    
    // MARK: Constants
    private struct Constants {
        static let maxRemainingTime = 120 // seconds
    }
}
