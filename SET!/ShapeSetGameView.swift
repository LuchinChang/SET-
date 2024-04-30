//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject var shapeSetGame: ShapeSetGame
    
    let cardAspectRatio: Double = 2/3
    let deckWidth: CGFloat = 70
    
    var body: some View {
        Group {
            if shapeSetGame.isFinished { finishedView }
            else { playingView }
        }
    }
    
    var playingView: some View {
        VStack(spacing: 0) {
            banner.padding()
            playingAreaView
            Spacer()
            bottom
        }
        .padding()
    }
    
    var playingAreaView: some View {
        AspectVGridWithScrollOption(shapeSetGame.cardsOnTable, aspectRatio: cardAspectRatio) { card in
            if card.status == .onTable {
                buildCardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            shapeSetGame.choose(card)
                        }
                    }
            }
        }
    }
    
    func buildCardView(_ card: SetGame.Card) -> some View {
        let (number, shading, color, shape) = shapeSetGame.getSymbolFeatures(card)
        return CardView(card, number, shading, color, shape)
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
    
    var hint: some View {
        VStack {
            Button("Hint") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    shapeSetGame.hint()
                }
            }
            .font(.largeTitle)
            .bold()
            .padding(.bottom, 3)
            
            Text("\(shapeSetGame.cardsInDeck.count) / 81")
                .foregroundStyle(.gray)
        }
    }
    
    @Namespace private var discardNamespace
    var discardPile: some View {
        ZStack {
            ForEach(Array(shapeSetGame.cardsMatched.enumerated()), id: \.element.id) { index, card in
                buildCardView(card)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
//                    .offset(y: CGFloat(index) * -1)
            }
        }
        .frame(width: deckWidth, height: deckWidth / cardAspectRatio)
    }
    
    @Namespace private var dealingNamespace
    var deck: some View {
        ZStack {
            ForEach(Array(shapeSetGame.cardsInDeck.enumerated()), id: \.element.id) { index, card in
                buildCardView(card)
                    .foregroundStyle(.yellow)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                //                    .offset(y: CGFloat(index) * -1)
            }
        }
        .onTapGesture {
            deal(3)
        }
        .frame(width:deckWidth, height: deckWidth / cardAspectRatio)
    }
    
    private func deal(_ numOfCards: Int) {
        var delay: TimeInterval = 0
        for _ in 0..<numOfCards {
            withAnimation(.easeInOut(duration: 1).delay(delay)) {
                shapeSetGame.deal(1)
            }
            delay += 0.2
        }
    }
    
    var finishedView: some View {
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
        }
        .background(.yellow)
        .onTapGesture {
           newGame()
        }
    }
       
    var banner: some View {
        VStack(spacing:0) {
            title
            newGameButtone
        }
    }
    
    var newGameButtone: some View {
        Button("⨁") {
            newGame()
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
    
    var title: some View {
        Text(" SET! ")
            .font(.largeTitle)
            .bold()
            .italic()
            .foregroundStyle(.blue)
            .background(Color.yellow)
            .cornerRadius(10)
            .padding(.vertical, 1)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            
    }
    
    private func newGame() {
        shapeSetGame.newGame()
        deal(12)
    }
    
    init(shapeSetGame: ShapeSetGame) {
        self.shapeSetGame = shapeSetGame
        newGame()
    }
}





#Preview {
    ShapeSetGameView(shapeSetGame: ShapeSetGame())
}
