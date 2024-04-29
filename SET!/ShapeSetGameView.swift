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
            banner
                .padding()
            AspectVGridWithScrollOption(shapeSetGame.cardsOnTable, aspectRatio: cardAspectRatio) { card in
                buildCardView(card)
                    .onTapGesture {
                        shapeSetGame.choose(card)
                    }
            }
            Spacer()
            bottom
        }
        .padding()
    }
    
    func buildCardView(_ card: SetGame.Card) -> some View {
        let (number, shading, color, shape) = shapeSetGame.getSymbolFeatures(card)
        return CardView(card, number, shading, color, shape)
    }
    
    var bottom: some View {
        HStack {
            setPile
            Spacer()
            hint
            Spacer()
            deck
        }
        .padding(3.5)
//        .background(.green)
    }
    
    var hint: some View {
        VStack {
            Button("Hint") {
                shapeSetGame.hint()
            }
            .font(.largeTitle)
            .bold()
            .padding(3)
            
            Text("\(shapeSetGame.cardsInDeck.count) / 81")
                .foregroundStyle(.gray)
        }
//        .foregroundStyle(.blue)
    }
    
    var setPile: some View {
        ZStack {
            ForEach(Array(shapeSetGame.cardsMatched.enumerated()), id: \.element.id) { index, card in
                buildCardView(card)
//                    .offset(y: CGFloat(index) * -1)
            }
        }
        .frame(width: deckWidth, height: deckWidth / cardAspectRatio)
    }
    
    var deck: some View {
        ZStack {
            ForEach(Array(shapeSetGame.cardsInDeck.enumerated()), id: \.element.id) { index, card in
                buildCardView(card)
                    .foregroundStyle(.yellow)
                //                    .offset(y: CGFloat(index) * -1)
            }
        }
        .onTapGesture {
            shapeSetGame.deal()
        }
        .frame(width:deckWidth, height: deckWidth / cardAspectRatio)
    }
    
    var dealButton: some View {
        Button("Deal") {
            shapeSetGame.deal()
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
    
    var finishedView: some View {
        VStack {
            Spacer()
            Text("Congrats!!")
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
            Spacer()
            Text("(touch to start a new game)")
                .foregroundStyle(.gray)
        }
        .onTapGesture {
            shapeSetGame.newGame()
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
            shapeSetGame.newGame()
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
}





#Preview {
    ShapeSetGameView(shapeSetGame: ShapeSetGame())
}
