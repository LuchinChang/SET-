//
//  SetBlitzGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/1.
//

import SwiftUI

struct SetBlitzGameView: View {
    @ObservedObject var blitzSetGame: SetBlitzViewModel
    
    var body: some View {
        Text("SetBlitz!!")
    }
    
    
    init(_ blitzSetGame: SetBlitzViewModel) {
        self.blitzSetGame = blitzSetGame
    }
}

//#Preview {
//    SetBlitzGameView(SetBlitzViewModel())
//}
