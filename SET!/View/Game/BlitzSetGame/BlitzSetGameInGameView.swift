//
//  BlitzSetGameInGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI
import GameKit

struct BlitzSetGameInGameView: View {
    @EnvironmentObject var blitzSetGame: SetBlitzVM
    @EnvironmentObject var gameManager: GameManager
    
    @Namespace private var dealingNamespace
    @Namespace private var discardNamespace
    
    var abilityIsActive: Bool { blitzSetGame.abilityNumber > 0 }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                BlitzSetBannerView(size: geo.size.width, discardNameSpace: discardNamespace)
                Spacer()
                cardBoard
                Spacer()
                bottom
            }
            .padding()
        }
        .onAppear {
            blitzSetGame.newGame()
        }
    }
    
    var cardBoard: some View {
        CardBoardVew(
            blitzSetGame.cardsOnTable,
            dealingNamespace: dealingNamespace,
            discardNamespace: discardNamespace,
            choose: blitzSetGame.choose
        )
    }
    
    var hint: some View {
        Button("Hint") {
            withAnimation() {
                blitzSetGame.hint()
            }
        }
        .font(.largeTitle)
        .bold()
        .foregroundStyle(abilityIsActive ? ViewStyle.textColor : .gray)
        .disabled(!abilityIsActive)
    }
    
    var deck: some View {
        PileOfCardsView(blitzSetGame.cardsInDeck, nameSpace: dealingNamespace, size: Constants.cardWidth)
            .foregroundStyle(ViewStyle.Card.backColor)
            .onTapGesture {
                blitzSetGame.dealWithAnimation(3)
            }
    }
        
    var bottom: some View {
        HStack {
            ability
            Spacer()
            VStack {
                timer
                hint
            }
            Spacer()
            deck
        }
        .padding()
    }
    
    var ability: some View {
        Button(action: blitzSetGame.abilityShuffle) {
            Image(systemName: "shuffle")
        }
        .foregroundStyle(abilityIsActive ? ViewStyle.textColor : .gray)
        .frame(width: Constants.cardWidth + 5, height: (Constants.cardWidth + 5) / ViewStyle.Card.aspectRatio)
        .disabled(!abilityIsActive)
        .buttonStyle(ButtonViewStyle.ability)
    }
    
    var timer: some View {
        TimerView(blitzSetGame.remainingTime)
    }
    
    private struct Constants {
        static let cardWidth: CGFloat = 70
    }
}

#Preview {
    BlitzSetGameInGameView()
        .environmentObject(SetBlitzVM(GKMatch.init(), localPlayer: GKLocalPlayer.local, developerMode: false))
}
