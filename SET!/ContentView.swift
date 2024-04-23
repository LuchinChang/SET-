//
//  ContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Group {
            if gameFinished {
                finishedView
            } else {
                playingView
            }
        }
    }
    
    var playingView: some View {
        VStack() {
            title
                .background(.red)
            Spacer()
            ScrollView {
                cards
            }
            .background(.green)
            Spacer()
            dealButton
//                .background(.blue)
        }
        .padding()
    }
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
            ForEach(0..<12) { index in
                CardView()
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(3)
            }
        }
    }
    
    var dealButton: some View {
        Button("Deal") {
            // FIX ME
            print("hi")
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
    
    var finishedView: some View {
        VStack {
            title
        }
    }
        
    var title: some View =
        Text("SET!")
            .font(.largeTitle)
            .padding(.top, 2)
   
    
    
    // MARK: - Debug Variables
    let gameFinished = false
        
}





#Preview {
    ContentView()
}
