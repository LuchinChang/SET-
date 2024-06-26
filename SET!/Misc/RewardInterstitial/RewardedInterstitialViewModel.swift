//
//  RewardedInterstitialViewModel.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/5.
//

import GoogleMobileAds

class RewardedInterstitialViewModel: NSObject, ObservableObject,
                                     GADFullScreenContentDelegate
{
    @Published var coins = 0
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    
    func loadAd() async {
        do {
            rewardedInterstitialAd = try await GADRewardedInterstitialAd.load(
                withAdUnitID: "ca-app-pub-8619899627454280/7968094433", request: GADRequest())
            rewardedInterstitialAd?.fullScreenContentDelegate = self
        } catch {
            print(
                "Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    func showAd() {
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            return print("Ad wasn't ready.")
        }
        
        rewardedInterstitialAd.present(fromRootViewController: nil) {
            let reward = rewardedInterstitialAd.adReward
            print("Reward amount: \(reward.amount)")
            self.addCoins(reward.amount.intValue)
        }
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    // MARK: - GADFullScreenContentDelegate methods
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        rewardedInterstitialAd = nil
    }
}
