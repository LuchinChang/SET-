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
    
    var cardsAllDealt: Bool { game.cardsAllDealt }
    var isFinished: Bool { game.isFinished }
    var cardsOnTable: Array<SetGame.Card> { game.cards.filter {$0.status == .onTable} }
//    var cards: Array<SetGame.Card> { game.cards }
   
    
    // MARK: - Intent
    func choose(_ card: SetGame.Card) {
        game.chooseCard(card)
    }
    
    func hint() {
        var available: Bool
        var availableSet = [Int]()
        let cards = game.cards
        let selectedCards = cards.indices.filter({ cards[$0].isSelected })
        
        if selectedCards.count < 3 {
            (available, availableSet) = game.findAvailableSet()
            
            if available {
                // Deselect currently selected cards
                for selectedCardIndex in selectedCards {
                    choose(cards[selectedCardIndex])
                }
                // Select a Set
                for cardIndex in availableSet {
                    choose(cards[cardIndex])
                }
            }
        }
        else {
            if let firstCard = selectedCards.first {
                choose(cards[firstCard])
            }
        }
    }
   
    func deal() {
        game.deal()
    }
    
    func newGame() {
        game = ShapeSetGame.createSetGame()
    }
    
    private static func createSetGame() -> SetGame {
        SetGame()
    }
    
    func getSymbolQuantity (_ card: SetGame.Card) -> Int {
        theme.feat1Factory(card.features[0])
    }
    
    func getSymbolShadingType(_ card: SetGame.Card) -> SymbolShading {
        theme.feat2Factory(card.features[1])
    }
    
    func getSymbolColor (_ card: SetGame.Card) -> Color {
        theme.feat3Factory(card.features[2])
    }
    
    func getSymbolShape (_ card: SetGame.Card) -> AnyShape {
        theme.feat4Factory(card.features[3])
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
