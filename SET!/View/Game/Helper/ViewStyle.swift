//
//  ViewStyle.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/8.
//

import SwiftUI


enum ViewStyle {
    static let backgroundColor: Color = .yellow
    static let textColor: Color = .blue
    
    struct Card {
        static let aspectRatio: Double = 2/3
        static let backColor: Color = .yellow
    }
    
    struct ButtonColor {
        static let text: Color = .blue
        static let background: Color = .yellow
    }
}

enum TextViewStyle {
    static let gameOverTextStyle = GameOverText()
    
    struct GameOverText: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.largeTitle)
                .bold()
                .italic()
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
        }
    }
}
    
enum ButtonViewStyle {
    typealias buttonColor = ViewStyle.ButtonColor
    
    static let primary = Primary()
    static let inGameSymbol = InGameSymbol()
    static let ability = Ability()
    
    struct Primary: ButtonStyle {
        let backgroundShape: some View = Capsule().aspectRatio(5.5, contentMode: .fit)
        
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
    
    struct InGameSymbol: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                    .font(.title)
                    .foregroundStyle(buttonColor.text)
            }
        }
    }
    
    struct Ability: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.largeTitle)
                .aspectRatio(contentMode: .fit)
                .opacity(configuration.isPressed ? 0.3 : 1)
                .cardify()
        }
    }
}

struct TimerStyler: ViewModifier {
    @ScaledMetric(relativeTo: .body) var fontSize = 50
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .heavy))
            .bold()
            .italic()
            .foregroundStyle(.blue)
    }
}

struct ScoreStyler: ViewModifier {
    @ScaledMetric(relativeTo: .body) var fontSize = 20
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.blue)
            .bold()
            .font(.title2)
    }
}

extension View {
    func scoreStyle() -> some View {
        modifier(ScoreStyler())
    }
    func timerStyle() -> some View {
        modifier(TimerStyler())
    }
}
