//
//  GameOverView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/27.
//

import SwiftUI

struct PractiveSetGameOverView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        VStack {
            Spacer()
            Text("Congratulations!!")
                .modifier(TextViewStyle.gameOverTextStyle)
            
            Spacer()
            
            backToMenu
        }
        .background(.yellow)
    }
    
    var backToMenu: some View {
        Button(action: gameManager.finishGame) {
            Text("Back To Menu")
        }
    }

}
