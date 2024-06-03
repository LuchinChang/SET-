//
//  MenuView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import SwiftUI
import GameKitUI

struct MenuView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.yellow).edgesIgnoringSafeArea(.all)
                VStack() {
                    NavigationLink(destination: GKGameCenterView().ignoresSafeArea()) {
                        Text("LeaderBoard")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    NavigationLink(destination: GameModeChoosingView()) {
                        Text("Start Game!")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .navigationTitle(Text("Menu"))
        }
    }
}

#Preview {
    MenuView()
}
