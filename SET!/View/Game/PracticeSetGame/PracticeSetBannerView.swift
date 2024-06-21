//
//  BannerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/19.
//

import SwiftUI

struct PracticeSetBannerView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var practiceSetGame: SetPracticeVM
    
    var body: some View {
        HStack {
            newGameButton
            Spacer()
            score
            Spacer()
            leaveButton
        }
        .buttonStyle(ButtonViewStyle.inGameSymbol)
    }
    
    var newGameButton: some View {
        Button(action: practiceSetGame.newGame) {
            Image(systemName: "arrow.clockwise")
        }
    }
    
    var leaveButton: some View {
        Button(action: gameManager.finishGame) {
            Image(systemName: "xmark.circle")
        }
    }
    
    var score: some View {
        Text("\(practiceSetGame.cardsMatched.count / 3)")
            .font(.largeTitle)
            .foregroundStyle(ViewStyle.textColor)
            .animation(.spring)
    }
}

#Preview {
    PracticeSetBannerView()
}
