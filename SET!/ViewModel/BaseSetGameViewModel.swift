//
//  BaseSetGameViewModel.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI

class BaseSetGame: NSObject, SetGameViewModel {
    typealias Card = SetGame.Card
    
    private var theme: Theme
    @Published private var setGame: SetGame
        
    var cardsAllDealt: Bool { setGame.cardsAllDealt }
    var isOver: Bool { setGame.isFinished }
    var cards: Array<Card> { setGame.cards }
    var cardsInDeck: Array<Card> { cards.filter {$0.status == .inDeck} }
    var cardsOnTable: Array<Card> { cards.filter {$0.status == .onTable} }
    var cardsMatched: Array<Card> { cards.filter {$0.status == .matched} }
    
    var isMultiPlayer: Bool
    var playerNumber: (Int, Int)
    
    init(theme: Theme = Theme.shapeTheme, game: SetGame = SetGame(), isMultiPlayer: Bool = false, playerNumber: (Int, Int) = (1, 1)) {
        self.theme = theme
        self.setGame = game
        self.isMultiPlayer = isMultiPlayer
        self.playerNumber = playerNumber
    }
      
    func _choose(_ card: Card) {
        if card.status == .onTable {
            setGame.chooseCard(card)
        }
    }
    
    var _isOver: Bool { setGame.isFinished }
    
    // MARK: - Intent
    func choose(_ card: Card) {
        if card.status == .onTable {
            setGame.chooseCard(card)
        }
    }
    
    func hint() {
        var available: Bool
        var availableSet = [Int]()
        let selectedCards = cards.indices.filter({ cards[$0].isSelected })
        
        if selectedCards.count < 3 {
            (available, availableSet) = setGame.findAvailableSet()
            
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
        setGame.deal(numOfCards)
    }
    
    func _newGame() {
        setGame = SetGame()
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
