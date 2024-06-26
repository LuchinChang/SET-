//
//  AdCoordinator.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/5.
//

import Foundation
import GoogleMobileAds

class AdCoordinator: NSObject, ObservableObject {
    private var ad: GADInterstitialAd?
    
    func loadAd() {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-8619899627454280/4411992801", request: GADRequest()
        ) { ad, error in
            if let error = error {
                return print("Failed to load ad with error: \(error.localizedDescription)")
            }
            self.ad = ad
        }
    }
    
    func presentAd() {
        guard let fullScreenAd = ad else {
            return print("Ad wasn't ready")
        }
        
        fullScreenAd.present(fromRootViewController: nil)
    }
}
