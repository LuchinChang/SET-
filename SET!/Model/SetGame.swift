//
//  SetGame.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    private var lastDealtCardIndex = 0
    var isFinished: Bool {
        // Check if there are sets available on table
        var setsAvailable = true
        
        if cards.indices.filter({ cards[$0].status == .matched }).count > 60 {
            (setsAvailable, _) = findAvailableSet()
        }
        
        return !setsAvailable
    }
    var cardsAllDealt: Bool {
        lastDealtCardIndex >= Constants.numOfCards
    }
        
    init() {
        cards = []
        for f1 in 0..<3 {
            for f2 in 0..<3 {
                for f3 in 0..<3 {
                    for f4 in 0..<3 {
                        cards.append(
                            Card(id: "\(f1)\(f2)\(f3)\(f4)",
                                 featureIndices: [f1, f2, f3, f4]
                                 )
                        )
                    }
                }
            }
        }
        
        cards.shuffle()
    }
    
    // Return (Bool: If there are still available sets on table, card indicies of the available set)
    func findAvailableSet() -> (Bool, [Int]) {
        var setsAvailable = false
        let cardsOnTable = cards.indices.filter({ cards[$0].status == .onTable })
    
        let possibleSets = combos(elements: cardsOnTable, k: Constants.numOfCardsOfAMatchedSet)
        var avaiableSet = [-1, -1, -1]
        
        for cardSet in possibleSets {
            
            if setsAvailable { break }
            
            if let matched = cardsAreMatched(cardSet) {
                avaiableSet = cardSet
                setsAvailable = matched
            }
        }
        
        return (stillHaveSets: setsAvailable, cardIndicesOfSet: avaiableSet)
    }
    
    mutating func deal(_ numberofCards: Int = Constants.defaultNumofDealingCards) {
        let matchedCards = cards.indices.filter({ cards[$0].isMatched == true })
        
        if matchedCards.count == Constants.numOfCardsOfAMatchedSet {
            dealInPlace(matchedCards)
        }
        else {
            for _ in 0..<numberofCards {
                if dealOneCard() == nil { break }
            }
        }
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
    // Return nil if the number of cards passed in != Constants.numOfCardsOfAMatchedSet
    private func cardsAreMatched(_ cardsIndices: [Int]) -> Bool? {
        if cardsIndices.count != Constants.numOfCardsOfAMatchedSet {
            return nil
        }
        
        var matched = true
        for indexOfFeatures in 0..<Constants.numOfFeatures {
            if !matched { break }
                
            let featureisMatched = featuresAreMatched(featureIndices: [
                cards[cardsIndices[0]].featureIndices[indexOfFeatures],
                cards[cardsIndices[1]].featureIndices[indexOfFeatures],
                cards[cardsIndices[2]].featureIndices[indexOfFeatures]
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
        if let chosenCardsIndex = cards.firstIndex(where: { $0.id == card.id }) {
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
            
            if matched != true  || !chosenSetOfCards.contains(chosenCardsIndex) {
                cards[chosenCardsIndex].isSelected.toggle()
            }
        }
        
        if let matched = cardsAreMatched(allChosenCardsIndices) {
            allChosenCardsIndices.forEach {
                cards[$0].isMatched = matched
            }
        }
    }
    
    struct Constants {
        static let numOfFeatures = 4
        static let numOfCards = 81
        static let startingNumOfCards = 12
        static let defaultNumofDealingCards = 3
        static let numOfCardsOfAMatchedSet = 3
    }
    
    struct Card: Identifiable, CustomStringConvertible {
        let id: String
        var status = cardStatus.inDeck
        var isSelected = false
        var isMatched: Bool? = nil
        let featureIndices: [Int]
        var isFaceUp: Bool {
            self.status == .inDeck ? false : true
        }
        
        var description: String {
            id + "\n" + "\(status) " + "isSelected \(isSelected) " + "isMatched \(String(describing: isMatched))"
        }
        
        enum cardStatus: String {
            case inDeck
            case onTable
            case matched
        }
    }
    
}
