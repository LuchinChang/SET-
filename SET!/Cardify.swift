//
//  Cardify.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/29.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool = true
    var isSelected: Bool = true
    var isMatched: Bool? = nil
    
    init(isFaceUp: Bool, isSelected: Bool, isMatched: Bool? = nil) {
        self.isFaceUp = isFaceUp
        self.isSelected = isSelected
        self.isMatched = isMatched
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(lineWidth: isSelected ? Constants.lineWidth.Selected : Constants.lineWidth.nonSelected)
                .background(base.fill(.white))
                .overlay(content)
                .matchedView(isMatched: isMatched)
                .opacity(isFaceUp ? 1 : 0)
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
//        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        struct lineWidth {
            static let Selected: CGFloat = 4
            static let nonSelected: CGFloat = 2
        }
    }
}

struct Match: ViewModifier {
    var isMatched: Bool? = nil
    
    func body(content: Content) -> some View {
        Group {
            if let isMatched {
                content.overlay(matchedView(isMatched))
            }
            else {
                content
            }
        }
    }
    
    func matchedView(_ isMatched: Bool) -> some View {
        Text(isMatched ? Constants.matchedIndicator : Constants.noMatchedIndicator)
            .foregroundStyle(isMatched ? .green : .red)
            .font(.system(size: 200))
            .minimumScaleFactor(0.01)
            .aspectRatio(1, contentMode: .fit)
    }
    
    private struct Constants {
        static let matchedIndicator = "✓"
        static let noMatchedIndicator = "X"
    }
}

extension View {
    func cardify(isFaceUp: Bool, isSelected: Bool, isMatched: Bool?) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isSelected: isSelected, isMatched: isMatched))
    }
    
    func matchedView(isMatched: Bool?) -> some View {
        modifier(Match(isMatched: isMatched))
    }
}
