//
//  BannerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/11.
//

import SwiftUI
import GameKit

struct BlitzSetBannerView: View {
    @EnvironmentObject var blitzSetGame: SetBlitzVM
    
    let size: CGFloat
    let discardNamespace: Namespace.ID
    
    var body: some View {
        playerStatus
    }
    
    var playerStatus: some View {
        HStack {
            VStack {
                ZStack {
                    discardPile // so that the matched card will fly back to the player's photo
                    PlayerProfileView(blitzSetGame.localPlayer, size: size)
                }
                Text(String(blitzSetGame.myScore))
            }
            
            ForEach(blitzSetGame.remotePlayers.elements, id:\.key) { _, status in
                Spacer()
                
                VStack {
                    PlayerProfileView(status.playerInstance, size: size)
                    Text(String(status.score))
                }
            }
        }
        .scoreStyle()
    }
    
    var discardPile: some View {
        PileOfCardsView(blitzSetGame.cardsMatched, nameSpace: discardNamespace, size: 1)
    }
    
    
    init(size: CGFloat, discardNameSpace: Namespace.ID) {
        self.size = size / 6
        self.discardNamespace = discardNameSpace
    }
}
