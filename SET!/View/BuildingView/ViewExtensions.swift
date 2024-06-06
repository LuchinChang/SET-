//
//  ViewExtensions.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI

extension BaseSetGame {
    func dealWithAnimation(_ numOfCards: Int) {
        
        var delay: TimeInterval = 0
        for _ in 0..<numOfCards {
            withAnimation(.easeInOut(duration: 1).delay(delay)) {
                deal(1)
            }
            delay += 0.2
        }
    }
    
    func newGame() {
        _newGame()
        dealWithAnimation(12)
    }
}
