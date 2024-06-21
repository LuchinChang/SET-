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
            matchRequest: GameCenterHelper.default.getMatchRequest(),
//            matchmakingMode: GameCenterHelper.defaultHelper.matchMakingMode,
            canceled: { GameCenterHelper.default.matchCancelled() },
            failed: { error in GameCenterHelper.default.matchFailed(error: error) },
            started: { match in
                GameCenterHelper.default.matchSucceeded(newMatch: match)
            }
        )
    }
}

#Preview {
    MatchMakingView()
}
