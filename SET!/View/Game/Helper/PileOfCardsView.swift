//
//  PileOfCards.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/20.
//

import SwiftUI

struct PileOfCardsView: View {
    var cards: [SetGame.Card]
    let nameSpace: Namespace.ID
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                BaseSetGameVM.buildCardView(card)
                    .matchedGeometryEffect(id: card.id, in: nameSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: size, height: size / ViewStyle.Card.aspectRatio)
    }
    
    init(_ cards: [SetGame.Card], nameSpace: Namespace.ID, size: CGFloat) {
        self.cards = cards
        self.nameSpace = nameSpace
        self.size = size
    }
    
}



//#Preview {
//    PileOfCards(cards: [.init(id: 1, featureIndices: [1, 2, 3, 0])])
//}
