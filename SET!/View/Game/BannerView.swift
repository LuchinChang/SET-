//
//  BannerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/11.
//

import SwiftUI
import GameKit

struct BannerView: View {
    @EnvironmentObject var blitzSetGame: SetBlitzViewModel
    
    let size: CGFloat
    
    @State var localPlayerProfile: PlayerProfileView = .localPlayer
    @State var opponentProfile: PlayerProfileView = .localPlayer

    var localPlayerStatus: some View {
        VStack {
            localPlayerProfile
            Text(String(blitzSetGame.myScore)).scoreStyle()
        }
    }
    
    var opponentStatus: some View {
        VStack {
            opponentProfile
            Text(String(blitzSetGame.opponentScore)).scoreStyle()
        }
    }
    
    var timer: some View {
        Text(secToMinSecFormat(blitzSetGame.remainingTime))
            .timerStyle()
    }
    
    var body: some View {
        HStack(alignment: VerticalAlignment.center) {
            localPlayerStatus
            Spacer()
            timer
            Spacer()
            opponentStatus
        }
        .onAppear {
            loadProfile()
        }
    }
    
    func loadProfile() {
        self.localPlayerProfile = PlayerProfileView(blitzSetGame.localPlayer, displayName: false, size: size/6)
        self.opponentProfile = PlayerProfileView(blitzSetGame.match.players.first!, displayName: false, size: size / 6)
    }
    
    func secToMinSecFormat(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        
        return "\(min): \(sec)"
    }
    
    init(size: CGFloat) {
        self.size = size
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
