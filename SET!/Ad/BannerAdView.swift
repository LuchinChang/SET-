//
//  AdView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/5.
//

import UIKit
import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero
    @EnvironmentObject var gameManager: GameManager
    
    private let bannerView = GADBannerView()
    private let adUnitID = "ca-app-pub-8619899627454280/8987863762"
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        
        bannerViewController.delegate = context.coordinator
        bannerView.delegate = context.coordinator
        
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }
        
        // Request a banner ad with the updated viewWidth.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {
        let parent: BannerAdView
        
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
        
        // MARK: - BannerViewControllerWidthDelegate methods
        
        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }
        
        // MARK: - GADBannerViewDelegate methods
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("DID RECEIVE AD")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("DID NOT RECEIVE AD: \(error.localizedDescription)")
        }
        
//        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
//            print("\(#function) called")
//        }
//        
//        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
//            print("\(#function) called")
//        }
//        
//        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
//            print("\(#function) called")
//        }
//        
//        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
//            print("\(#function) called")
//        }
    }
}

// Delegate methods for receiving width update messages.
protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Tell the delegate the initial ad width.
        delegate?.bannerViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }
    
    override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // do nothing
        } completion: { _ in
            // Notify the delegate of ad width changes.
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
        }
    }
}
