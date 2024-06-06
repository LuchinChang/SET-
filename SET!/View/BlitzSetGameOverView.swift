//
//  BlitzSetGameOverView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI

struct BlitzSetGameOverView: View {
    typealias Msg = SetBlitzViewModel.Msg
    
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var blitzSetGame: SetBlitzViewModel
    @EnvironmentObject var adCoordinator: AdCoordinator
    
    var body: some View {
        VStack {
            Spacer()
//            Text("Congratulations!!")
            switch blitzSetGame.isWinner {
            case true:
                winView
            case false:
                loseView
            }
                
            Spacer()
            playAgain
            backToMenu
        }
        .onAppear {
            adCoordinator.presentAd()
        }
        .background(.yellow)
        .alert(Msg.PlayAgain.Alert.message, isPresented: $blitzSetGame.showPlayAgainInvitation) {
            Button("Yes") {
                blitzSetGame.processPlayAgainInvitation(wantsToPlayAgain: true)
            }
            Button("No") {
                blitzSetGame.processPlayAgainInvitation(wantsToPlayAgain: false)
            }
        }

    }
    
    var playAgain: some View {
        Button {
            blitzSetGame.inviteToPlayAgain()
        } label: {
            Text("Restart")
        }
    }
    
    var backToMenu: some View {
        Button {
            gameManager.finishGame()
        } label: {
            Text("Back To Menu")
        }
    }
    
    var winView: some View {
        Text("Victory!!")
            .font(.largeTitle)
            .bold()
            .italic()
            .foregroundStyle(.blue)
            .frame(maxWidth: .infinity)
    }
    
    var loseView: some View {
        Text("Defeat..")
            .font(.largeTitle)
            .bold()
            .italic()
            .foregroundStyle(.blue)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    BlitzSetGameOverView()
}
