//
//  SetGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
    private var theme = createTheme()
    @Published private var game = createSetGame()
    
    var isFinished: Bool { game.isFinished }
    var cards: Array<SetGame.Card> { game.cards.filter {$0.status == .onTable} }
   
    
    // MARK: - Intent
    func choose(_ card: SetGame.Card) {
        game.chooseCard(card)
    }
    
    
    private static func createSetGame() -> SetGame {
        SetGame()
    }
    
    func getSymbolQuantity (_ card: SetGame.Card) -> Int {
        theme.feat1Factory(card.featureIndex.0)
    }
    
    func getSymbolShadingType(_ card: SetGame.Card) -> SymbolShading {
        theme.feat2Factory(card.featureIndex.1)
    }
    
    func getSymbolColor (_ card: SetGame.Card) -> Color {
        theme.feat3Factory(card.featureIndex.2)
    }
    
    func getSymbolShape (_ card: SetGame.Card) -> AnyShape {
        theme.feat4Factory(card.featureIndex.3)
    }
    
    // Number, Shading, Color, Shape
    private static func createTheme() -> Theme<Int, SymbolShading, Color, AnyShape> {
        Theme(
            feat1Factory: { index in
                index + 1
            },
            feat2Factory: { index in
                SymbolShading(rawValue:index)!
            },
            feat3Factory: { index in
                SymbolColor(rawValue:index)!.getColor()
            },
            feat4Factory: { index in
                SymbolShape(rawValue:index)!.getShape()
            }
        )
    }
}

enum SymbolShading: Int {
    case solid
    case semiTransparent
    case open
}

enum SymbolColor: Int {
    case blue
    case purple
    case orange
    
    func getColor() -> Color {
        switch self {
        case .blue:
            return .blue
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}

enum SymbolShape: Int {
    case rectangle
    case diamond
    case ellipse
    
    func getShape() -> AnyShape {
        switch self {
        case .rectangle:
            return AnyShape(Rectangle())
        case .diamond:
            return AnyShape(RoundedRectangle(cornerRadius: 12))
        case .ellipse:
            return AnyShape(Ellipse())
        }
    }
}

struct AnyShape: Shape {
    private let pathClosure: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) where S: Sendable {
        self.pathClosure = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathClosure(rect)
    }
}
