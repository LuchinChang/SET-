//
//  BlitzSetGameOverView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI
import GameKit

struct BlitzSetGameOverView: View {
    typealias Msg = SetBlitzVM.Msg
    
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var blitzSetGame: SetBlitzVM
    
    var body: some View {
        VStack {
            Spacer()
            resultText
            Spacer()
//            playAgain
//            backToMenu
            Text("touch to back to Menu")
                .font(.body)
                .foregroundStyle(.gray)
        }
        .background(ViewStyle.backgroundColor)
        .onTapGesture {
            gameManager.finishGame()
        }
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
        .buttonStyle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Button Style@*/DefaultButtonStyle()/*@END_MENU_TOKEN@*/)
    }
    
    var backToMenu: some View {
        Button {
            gameManager.finishGame()
        } label: {
            Text("Back To Menu")
        }
    }
    
    var resultText: some View {
        Text(blitzSetGame.isWinner ? "Victory!!" : "Defeat..")
            .font(.largeTitle)
            .bold()
            .italic()
            .foregroundStyle(.blue)
            .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    BlitzSetGameOverView()
//        .environmentObject(GameManager())
//        .environmentObject(SetBlitzVM(GKMatch.init(), localPlayer: GKLocalPlayer.local))
//}
