//
//  SetGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame.Card
    
    private var theme = createTheme()
    @Published private var game = createSetGame()
        
    var cardsAllDealt: Bool { game.cardsAllDealt }
    var isFinished: Bool { game.isFinished }
    var cards: Array<SetGame.Card> { game.cards }
    var cardsInDeck: Array<Card> { cards.filter {$0.status == .inDeck} }
    var cardsOnTable: Array<Card> { cards.filter {$0.status == .onTable} }
    var cardsMatched: Array<Card> { cards.filter {$0.status == .matched} }
    
    // MARK: - Intent
    func choose(_ card: SetGame.Card) {
        if card.status == .onTable {
            game.chooseCard(card)
        }
    }
    
    func hint() {
        var available: Bool
        var availableSet = [Int]()
//        let cards = game.cards
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
        
    func deal(_ numOfCards: Int = 3) {
        game.deal(numOfCards)
    }
    
    func newGame() {
        game = ShapeSetGame.createSetGame()
    }
    
    func getSymbolFeatures(_ card: Card) -> (Int, SymbolShading, Color, AnyShape) {
        return (
            number: theme.feat1Factory(card.features[0]),
            shading: theme.feat2Factory(card.features[1]),
            color: theme.feat3Factory(card.features[2]),
            shape: theme.feat4Factory(card.features[3])
        )
    }
    
    private static func createSetGame() -> SetGame {
        SetGame()
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
            },
            color: .yellow
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
            return AnyShape(Diamond(widthRatio: 1, heightRatio: 1))
        case .diamond:
            return AnyShape(RoundedRectangle(cornerRadius: 12))
        case .ellipse:
            return AnyShape(Ellipse())
        }
    }
}

