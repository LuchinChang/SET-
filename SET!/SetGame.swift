//
//  SetGame.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    private(set) var isFinished = false
    private let numOfFeatures = 3
    private let initialNumofCards = 12
    
    
    init() {
        cards = []
        for f1 in 0..<3 {
            for f2 in 0..<3 {
                for f3 in 0..<3 {
                    for f4 in 0..<3 {
                        cards.append(
                            Card(id: "\(f1)\(f2)\(f3)\(f4)",
                                 featureIndex: (f1, f2, f3, f4)
                                 )
                        )
                    }
                }
            }
        }
        
        cards.shuffle()
        
        for index in 0..<initialNumofCards {
            cards[index].status = .onTable
        }
    }
     
    mutating func chooseCard (_ card: Card) {
        if let chosenCardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chosenCardIndex].isSelected.toggle()
//            print(card)
        }
    }
    
    struct Card: Identifiable, CustomStringConvertible {
        var id: String
        var status = cardStatus.inDeck
        var isSelected = false
        var isMatched: Bool? = nil
        var featureIndex: (Int, Int, Int, Int)
        
        var description: String {
            id + "\n" + "\(status)"
        }
    }
    
    enum cardStatus: String {
        case inDeck
        case onTable
        case Matched
    }
}
