//
//  SetGame.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    private(set) var lastDealtCardIndex = 0
    var isFinished: Bool {
        cards.indices.filter({ cards[$0].status == .matched }).count == 81
    }
    var cardsAllDealt: Bool {
        lastDealtCardIndex > 80
    }
        
    init() {
        cards = []
        for f1 in 0..<3 {
            for f2 in 0..<3 {
                for f3 in 0..<3 {
                    for f4 in 0..<3 {
                        cards.append(
                            Card(id: "\(f1)\(f2)\(f3)\(f4)",
                                 features: [f1, f2, f3, f4]
                                 )
                        )
                    }
                }
            }
        }
        
        cards.shuffle()
        deal(numberofCards: 12)
    }
    
    // If there are cards in the deck, deal one.
    // Return the index of the newly dealt card.
    // Return nil if there is no more card in the deck.
    private mutating func dealOneCard() -> Int? {
        if !cardsAllDealt {
            cards[lastDealtCardIndex].status = .onTable
            lastDealtCardIndex += 1
            return lastDealtCardIndex - 1
        }
        return nil
    }
    
    mutating func deal(numberofCards: Int = 3) {
        let matchedCards = cards.indices.filter({ cards[$0].isMatched == true })
        
        if matchedCards.count == 3 {
            dealInPlace(matchedCards)
        }
        else {
            for _ in 0..<numberofCards {
                if dealOneCard() == nil { break }
            }
        }
    }
    
    private mutating func dealInPlace(_ indicesOfCardsBeingReplaced: [Int]) {
        indicesOfCardsBeingReplaced.forEach { replacee in
            // clean up the card that is being replaced
            cards[replacee].status = .matched
            cards[replacee].isSelected = false
            cards[replacee].isMatched = nil
            
            if let replacer = dealOneCard() {
                cards.swapAt(replacee, replacer)
            }
        }
    }
    
    private var allChosenCardsIndices: [Int] {
        cards.indices.filter {cards[$0].isSelected}
    }
    // Return true or false based on the rules
    // Return nil if the number of cards passed != 3
    private func cardsAreMatched(_ cardsIndices: [Int]) -> Bool? {
        if cardsIndices.count != 3 {
            return nil
        }
        
//        return true
        
        var matched = true
        for indexOfFeatures in 0..<4 {
            if !matched { break }
                
            let featureisMatched = featuresAreMatched(featureIndices: [
                cards[cardsIndices[0]].features[indexOfFeatures],
                cards[cardsIndices[1]].features[indexOfFeatures],
                cards[cardsIndices[2]].features[indexOfFeatures]
            ])
            
            matched = matched && featureisMatched
        }
        return matched
        
        func featuresAreMatched(featureIndices: [Int]) -> Bool {
            let numOfdifferentFeatures = Set(featureIndices).count
            return (numOfdifferentFeatures == 1 || numOfdifferentFeatures == 3)
        }
    }
    
    mutating func chooseCard(_ card: Card) {
        if let chosenCardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            let chosenSetOfCards = allChosenCardsIndices
            let matched = cardsAreMatched(chosenSetOfCards)
            
            if matched != nil {
                if matched! {
                    // Deal new cards which replace their spaces
                    dealInPlace(chosenSetOfCards)
                }
                else {
                    // Deselecte the cards
                    chosenSetOfCards.forEach {
                        cards[$0].isSelected = false
                        cards[$0].isMatched = nil
                    }
                }
            }
            
            if matched != true  || !chosenSetOfCards.contains(chosenCardIndex) {
                cards[chosenCardIndex].isSelected.toggle()
            }
        }
        
        if let matched = cardsAreMatched(allChosenCardsIndices) {
            allChosenCardsIndices.forEach {
                cards[$0].isMatched = matched
            }
        }
    }
    
    struct Card: Identifiable, CustomStringConvertible {
        let id: String
        var status = cardStatus.inDeck
        var isSelected = false
        var isMatched: Bool? = nil
        let features: [Int]
        
        var description: String {
            id + "\n" + "\(status)"
        }
    }
    
    enum cardStatus: String {
        case inDeck
        case onTable
        case matched
    }
}
