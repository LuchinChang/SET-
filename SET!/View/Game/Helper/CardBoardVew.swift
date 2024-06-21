//
//  CardBoardVew.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/20.
//

import SwiftUI

struct CardBoardVew: View {
    var cards: [SetGame.Card]
    let choose: (SetGame.Card) -> Void
    let dealingNamespace: Namespace.ID
    let discardNamespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            let minSize: CGFloat = geo.size.width / Constants.maxNumOfCardsPerRow
            let maxSize: CGFloat = geo.size.width / Constants.minNumOfCardsPerRow
            
            AspectVGridWithScrollOption(
                cards,
                aspectRatio: ViewStyle.Card.aspectRatio,
                minSizeForVGrid: minSize,
                maxSizeForVGrid: maxSize
            ) { card in
                if card.status == .onTable {
                    BaseSetGameVM.buildCardView(card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .matchedGeometryEffect(id: card.id, in: discardNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 0.1)) {
                                choose(card)
                            }
                        }
                }
            }
        }
    }
    
    struct Constants {
        static let minNumOfCardsPerRow: CGFloat = 4
        static let maxNumOfCardsPerRow: CGFloat = 5
    }
    
    init(_ cards: [SetGame.Card], dealingNamespace: Namespace.ID, discardNamespace: Namespace.ID, choose: @escaping (SetGame.Card) -> Void) {
        self.cards = cards
        self.choose = choose
        self.dealingNamespace = dealingNamespace
        self.discardNamespace = discardNamespace
    }
}

