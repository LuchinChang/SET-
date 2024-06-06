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
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            VStack(spacing:10) {
                ForEach (0..<number, id:\.self) { _ in
                    shape
                        .shadingify(shading)
                        .foregroundStyle(color)
                        .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                        .frame(width: width * Constants.widthPortion)
                }
            }
            .frame(width: width, height: height)
        }
    }
    
    private struct Constants {
        static let aspectRatio: Double = 5/1
        static let widthPortion: Double = 0.8
    }
}

extension Shape {
    func shadingify(_ shadingStyle: SymbolShading) -> some View {
        return Group {
            switch shadingStyle {
            case .open:
                self.stroke(lineWidth: 2)
            case.semiTransparent:
                self.fill()
                    .opacity(0.3)
            case .solid:
                self.fill()
            }
        }
    }
}



