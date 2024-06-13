//
//  GameOverView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/27.
//

import SwiftUI

struct PractiveSetGameOverView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var adCoordinator: AdCoordinator
    
    var body: some View {
        VStack {
            Spacer()
            Text("Congratulations!!")
                .font(.largeTitle)
                .bold()
                .italic()
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
            Spacer()
            Text("(touch to start a new game)")
                .bold()
                .foregroundStyle(.gray)
            
            backToMenu
        }
        .background(.yellow)
//        .onAppear {
//            adCoordinator.presentAd()
//        }
    }
    
    var backToMenu: some View {
        Button {
            gameManager.finishGame()
        } label: {
            Text("Back To Menu")
        }
    }

}
