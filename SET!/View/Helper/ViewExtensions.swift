//
//  ViewExtensions.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import SwiftUI

extension BaseSetGame {
    func dealWithAnimation(_ numOfCards: Int) {
        
        var delay: TimeInterval = 0
        for _ in 0..<numOfCards {
            withAnimation(.linear(duration: 1).delay(delay)) {
                deal(1)
            }
            delay += 0.2
        }
    }
    
    func newGame() {
        _newGame()
        dealWithAnimation(12)
    }
}

struct Rotate3DViewModifier: ViewModifier {
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(Angle(degrees: rotation), axis: (0, 1, 0))
    }
}

extension AnyTransition {
    static var rotation3DReverse: AnyTransition {
        AnyTransition.modifier(
            active: Rotate3DViewModifier(rotation: 0),
            identity: Rotate3DViewModifier(rotation: 180))
    }
    
    static var rotation3D: AnyTransition {
        AnyTransition.modifier(
            active: Rotate3DViewModifier(rotation: 180),
            identity: Rotate3DViewModifier(rotation: 0))
    }
}
