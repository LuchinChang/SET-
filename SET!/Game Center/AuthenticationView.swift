//
//  AuthenticationView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/6.
//

import SwiftUI
import GameKitUI

struct AuthenticationView: View {
    var body: some View {
        GKAuthenticationView { error in
            GameCenterHelper.defaultHelper.authenticationfailed(error: error)
        } authenticated: { player in
            GameCenterHelper.defaultHelper.authenticationSucceeded(player: player)
        }
    }
}
