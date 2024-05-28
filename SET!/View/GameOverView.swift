//
//  GameOverView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/27.
//

import SwiftUI

struct GameOverView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("Congratulations!!")
                .font(.largeTitle)
                .bold()
                .italic()
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
            Spacer()
            Text("(touch to start a new game)")
                .bold()
                .foregroundStyle(.gray)
        }
        .background(.yellow)
    }
}
//
//#Preview {
//    GameOverView()
//}