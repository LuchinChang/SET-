//
//  Cardify.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/29.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var isSelected: Bool
    var isMatched: Bool?
    
    init(isFaceUp: Bool = true, isSelected: Bool = false, isMatched: Bool? = nil) {
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
                .scaleEffect(isSelected ? Constants.scaleUp : 1)
                .padding(Constants.paddingSize)
                .opacity(isFaceUp ? 1 : 0)
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
//        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 8
        struct lineWidth {
            static let Selected: CGFloat = 3
            static let nonSelected: CGFloat = 2
        }
        static let scaleUp: CGFloat = 1.05
        static let paddingSize: CGFloat = 3.5
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
    func cardify(isFaceUp: Bool = true, isSelected: Bool = false, isMatched: Bool? = nil) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isSelected: isSelected, isMatched: isMatched))
    }
    
    func matchedView(isMatched: Bool?) -> some View {
        modifier(Match(isMatched: isMatched))
    }
}
