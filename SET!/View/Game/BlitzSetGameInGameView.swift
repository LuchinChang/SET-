//
//  BlitzSetGameInGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI
import GameKit

struct BlitzSetGameInGameView: View {
    @EnvironmentObject var blitzSetGame: SetBlitzViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack() {
                BannerView(size: geo.size.width)
                playingAreaView
                Spacer()
                bottom
            }
            .padding()
        }
        .onAppear {
            blitzSetGame.newGame()
        }
    }
    
    // MARK: PlayingArea
    var playingAreaView: some View {
        AspectVGridWithScrollOption(blitzSetGame.cardsOnTable, aspectRatio: Constants.cardAspectRatio) { card in
            if card.status == .onTable {
                buildCardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            blitzSetGame.choose(card)
                        }
                    }
            }
        }
    }
    
    func buildCardView(_ card: SetGame.Card) -> some View {
        let (number, shading, color, shape) = blitzSetGame.getSymbolFeatures(card)
        return CardView(card, number, shading, color, shape)
    }
    
    // MARK: Bottom
    @Namespace private var discardNamespace
    var discardPile: some View {
        ZStack {
            ForEach(Array(blitzSetGame.cardsMatched.enumerated()), id: \.element.id) { index, card in
                buildCardView(card)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.cardWidth, height: Constants.cardHeight)
    }
    
    var hint: some View {
        VStack {
            Button("Hint") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    blitzSetGame.hint()
                }
            }
            .font(.largeTitle)
            .bold()
            .padding(.bottom, 3)
            
            Text("\(blitzSetGame.cardsInDeck.count) / 81")
                .foregroundStyle(.gray)
        }
    }
    
    @Namespace private var dealingNamespace
    var deck: some View {
        ZStack {
            ForEach(Array(blitzSetGame.cardsInDeck.enumerated()), id: \.element.id) { index, card in
                buildCardView(card)
                    .foregroundStyle(.yellow)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .onTapGesture {
            blitzSetGame.dealWithAnimation(3)
        }
        .frame(width:Constants.cardWidth, height: Constants.cardHeight)
    }
        
    var bottom: some View {
        HStack {
            discardPile
            Spacer()
            hint
            Spacer()
            deck
        }
        .padding(3.5)
    }
    
    private struct Constants {
        static let cardAspectRatio: Double = 2/3
        static let cardWidth: CGFloat = 70
        static var cardHeight: CGFloat {
            cardWidth / cardAspectRatio
        }
    }
}

#Preview {
    BlitzSetGameInGameView()
        .environmentObject(SetBlitzViewModel(GKMatch.init(), localPlayer: GKLocalPlayer.local))
}
