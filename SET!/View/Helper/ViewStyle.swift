//
//  ViewStyle.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/8.
//

import SwiftUI


struct ViewStyle {
    static let backgroundColor: Color = .yellow
    
    struct ButtonColor {
        static let text: Color = .blue
        static let background: Color = .yellow
    }
}
    
struct ButtonViewStyle {
    typealias buttonColor = ViewStyle.ButtonColor
    
    static let backgroundShape: some View = Capsule().aspectRatio(5.5, contentMode: .fit)
    
    
    struct Primary: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                backgroundShape
                    .foregroundStyle(buttonColor.background)
                
                configuration.label
                    .font(.title)
                    .bold()
                    .foregroundStyle(buttonColor.text)
            }
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
        }
    }
}

    
