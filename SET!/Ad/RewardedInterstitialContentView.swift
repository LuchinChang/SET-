//
//  RewardedInterstitialContentView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/5.
//

import SwiftUI
import GoogleMobileAds

struct RewardedInterstitialContentView: View {
    @StateObject private var viewModel = RewardedInterstitialViewModel()
    @StateObject private var countdownTimer = CountdownTimer(10)
    @State private var showAdDialog = false
    @State private var showAd = false
    let navigationTitle: String
    
    var body: some View {
        ZStack {
            rewardedInterstitialBody
            
            AdDialogContentView(isPresenting: $showAdDialog, countdownComplete: $showAd)
                .opacity(showAdDialog ? 1 : 0)
        }
    }
    
    var rewardedInterstitialBody: some View {
        VStack(spacing: 20) {
            Text("Preparing ad in \(countdownTimer.timeLeft)")
            
            Button("Play Again") {
                startNewGame()
            }
            .font(.title2)
            .opacity(countdownTimer.isComplete ? 1 : 0)
            
            Spacer()
            
            HStack {
                Text("Coins: \(viewModel.coins)")
                Spacer()
            }
            .padding()
        }
        .onAppear {
            if !countdownTimer.isComplete {
                startNewGame()
            }
        }
        .onDisappear {
            countdownTimer.pause()
        }
        .onChange(of: countdownTimer.isComplete) { _, newValue in
            if newValue {
                showAdDialog = true
                viewModel.addCoins(1)
            }
        }
        .onChange(of: showAd) {_, newValue in
            if newValue {
                viewModel.showAd()
            }
        }
        .navigationTitle(navigationTitle)
    }
    
    private func startNewGame() {
        countdownTimer.start()
        Task {
            await viewModel.loadAd()
        }
    }
}

struct RewardedIntersititalContentView_Previews: PreviewProvider {
    static var previews: some View {
        RewardedInterstitialContentView(navigationTitle: "Rewarded Interstitial")
    }
}
