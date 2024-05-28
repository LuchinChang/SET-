//
//  theme.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import SwiftUI

struct Theme {
    let number: [Int]
    let shading: [SymbolShading]
    let color: [Color]
    let shape: [AnyShape]
    
    static let shapeTheme = Theme(
        number: [1, 2, 3],
        shading:[.open, .semiTransparent, .solid],
        color: [.blue, .purple, .orange],
        shape: [AnyShape(Diamond()), AnyShape(RoundedRectangle(cornerRadius: 12)), AnyShape(Ellipse())]
    )
}

enum SymbolShading: Int {
    case solid
    case semiTransparent
    case open
}

