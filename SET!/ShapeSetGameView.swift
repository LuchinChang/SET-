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
    
    
    var body: some View {
        Group {
            if shapeSetGame.isFinished {
                finishedView
            } else {
                playingView
            }
        }
    }
    
    var playingView: some View {
        VStack(spacing: 0) {
            banner
                .padding()
            AspectVGridWithScrollOption(shapeSetGame.cards, aspectRatio: cardAspectRatio, content: buildCardView(_:))
            if !shapeSetGame.cardsAllDealt {
                Spacer()
                dealButton
            }
        }
        .padding()
    }
    
    func buildCardView(_ card: SetGame.Card) -> some View {
        let number = shapeSetGame.getSymbolQuantity(card)
        let shading = shapeSetGame.getSymbolShadingType(card)
        let color = shapeSetGame.getSymbolColor(card)
        let shape = shapeSetGame.getSymbolShape(card)
        
        return CardView(card, number, shading, color, shape)
            .padding(3)
            .onTapGesture {
                shapeSetGame.choose(card)
            }
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
        .background(.gray)
        .onTapGesture {
            shapeSetGame.newGame()
        }
    }
       
    var banner: some View {
        VStack {
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
        Text("SET!")
            .font(.largeTitle)
            .padding(.vertical, 1)
            
    }
}





#Preview {
    ShapeSetGameView(shapeSetGame: ShapeSetGame())
}
