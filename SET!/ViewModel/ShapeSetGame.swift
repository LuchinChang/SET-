//
//  SetGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame.Card
    
    private var theme = Theme.shapeTheme
    @Published private var game = SetGame()
        
    var cardsAllDealt: Bool { game.cardsAllDealt }
    var isOver: Bool { game.isFinished }
    var cards: Array<Card> { game.cards }
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
        let selectedCards = cards.indices.filter({ cards[$0].isSelected })
        
        if selectedCards.count < 3 {
            (available, availableSet) = game.findAvailableSet()
            
            if available {
                // Deselect currently selected cards
                for selectedCardIndex in selectedCards {
                    choose(cards[selectedCardIndex])
                }
                // Select one Set
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
    
    func _newGame() {
        game = SetGame()
    }
    
    func getSymbolFeatures(_ card: Card) -> (Int, SymbolShading, Color, AnyShape) {
        return (
            number: theme.number[card.featureIndices[0]],
            shading: theme.shading[card.featureIndices[1]],
            color: theme.color[card.featureIndices[2]],
            shape: theme.shape[card.featureIndices[3]]
        )
    }
}
