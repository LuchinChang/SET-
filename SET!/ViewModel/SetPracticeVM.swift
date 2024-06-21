//
//  SetGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import SwiftUI
import OrderedCollections

class SetPracticeVM: BaseSetGameVM  {
    func whyCardsNotMatched() -> OrderedDictionary<String, Bool> {
        let cardsIndices = setGame.allChosenCardsIndices
        var result: OrderedDictionary<String, Bool> = [:]
        
        for indexOfFeatures in 0..<SetGame.Constants.numOfFeatures {
            let isMatched = SetGame.featureIsMatched([
                cards[cardsIndices[0]].featureIndices[indexOfFeatures],
                cards[cardsIndices[1]].featureIndices[indexOfFeatures],
                cards[cardsIndices[2]].featureIndices[indexOfFeatures]
            ])
            
            result[Theme.getFeatureName(indexOfFeatures)] = isMatched
        }
        
        return result
    }
}
