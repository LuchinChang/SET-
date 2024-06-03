//
//  PrimaryButtonStyle.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title)
            .padding(32)
//            .foregroundColor(configuration.isPressed ? Color("ButtonColor") : Color("ButtonTextColor"))
//            .background(configuration.isPressed ? Color("ButtonTextColor") : Color("ButtonColor"))
            .cornerRadius(32)
    }
}
