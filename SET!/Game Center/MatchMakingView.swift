//
//  MatchMakingView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/6.
//

import SwiftUI
import GameKitUI

struct MatchMakingView: View {
    var body: some View {
        GKMatchmakerView(
            matchRequest: GameCenterHelper.defaultHelper.getMatchRequest(),
            matchmakingMode: GameCenterHelper.defaultHelper.matchMakingMode,
            canceled: { GameCenterHelper.defaultHelper.matchCancelled() },
            failed: { error in GameCenterHelper.defaultHelper.matchFailed(error: error) },
            started: { match in
                GameCenterHelper.defaultHelper.matchSucceeded(newMatch: match)
            }
        )
    }
}

#Preview {
    MatchMakingView()
}
