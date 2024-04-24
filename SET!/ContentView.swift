//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var shapeSetGame: ShapeSetGame
    
    
    
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
        VStack() {
            banner
                .padding()
//                .background(.red)
            Spacer()
            ScrollView {
                cards
            }
//            .background(.brown)
            Spacer()
            dealButton
//                .background(.blue)
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
            ForEach(shapeSetGame.cards) { card in
                let number = shapeSetGame.getSymbolQuantity(card)
                let shading = shapeSetGame.getSymbolShadingType(card)
                let color = shapeSetGame.getSymbolColor(card)
                let shape = shapeSetGame.getSymbolShape(card)
                
                CardView(card, number, shading, color, shape)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(3)
                    .onTapGesture {
                        shapeSetGame.choose(card)
                    }
            }
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
            title
        }
    }
       
    var banner: some View {
        HStack {
//            Spacer()
            title
//            Spacer()
            newGameButtone
        }
    }
    
    var newGameButtone: some View {
        Button("⨁") {
            shapeSetGame.newGame()
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//        .frame(alignment: .trailing)
        
    }
    
    var title: some View {
        Text("SET!")
            .font(.largeTitle)
//            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            .padding(.top, 2)
            
    }
    
    
    // MARK: - Debug Variables
    let gameFinished = false
        
}





#Preview {
    ContentView(shapeSetGame: ShapeSetGame())
}
