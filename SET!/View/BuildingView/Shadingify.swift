//
//  Shadingify.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/28.
//

import SwiftUI

#Preview {
    VStack {
        Rectangle()
            .size(CGSize(width: 100.0, height: 100.0))
            .shadingify(.open)
            .foregroundStyle(.blue)
            .padding()
        
        Rectangle()
            .size(CGSize(width: 100.0, height: 100.0))
            .shadingify(.solid)
            .foregroundStyle(.blue)
            .padding()
        
        Rectangle()
            .size(CGSize(width: 100.0, height: 100.0))
            .shadingify(.semiTransparent)
            .foregroundStyle(.blue)
            .padding()
    }
}
