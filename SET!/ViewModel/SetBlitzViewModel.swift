//
//  SetBlitzViewModel.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI
import GameKit

class SetBlitzViewModel: ShapeSetGame, MultiPlayerViewModel {
    @Published var game: SetBlitz
//    
//    init() {
////        super.init(isMultiPlayer: true, playerNumber: (2, 2))
//    }
    
    var match: MultiPlayerMatch
    
    init(match: GKMatch) {
        self.game = SetBlitz()
        self.match = .init(match) { msg in
            print(msg)
        }
    }
    
}
