//
//  SwiftUIView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct CardView: View {
    private let card: SetGame.Card
    private let symbol: SymbolView
    
    init(_ card: SetGame.Card, _ number: Int, _ shading: SymbolShading, _ color: Color, _ shape: AnyShape) {
        self.card = card
        self.symbol = SymbolView(number: number, shading: shading, color: color, shape: shape)
    }
    
    var body: some View {
        symbol
            .cardify(isFaceUp: card.isFaceUp, isSelected: card.isSelected, isMatched: card.isMatched)
            .rotationEffect(Angle(degrees: card.isMatched == false ? 2.5 : 0))
            .scaleEffect(card.isMatched == true ? 1.05 : 1)
            .animation(.linear(duration: 0.1).repeat(while: card.isMatched != nil), value: card.isMatched)
    }
}

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

struct SymbolView: View {
    let number: Int
    let shading: SymbolShading
    let color: Color
    let shape: AnyShape
    
    let aspectRatio: Double = 5/1
    let widthPortion: Double = 0.8
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            VStack(spacing:10) {
                ForEach (0..<number, id:\.self) { _ in
                    shape
                        .stroke(color, lineWidth: shading == .open ? 2 : 0)
                        .fill(shading == .open ? .clear : color)
                        .opacity(shading == SymbolShading.semiTransparent ? 0.3 : 1)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .frame(width: width * widthPortion)
                }
            }
            .frame(width: width, height: height)
        }
    }
}



