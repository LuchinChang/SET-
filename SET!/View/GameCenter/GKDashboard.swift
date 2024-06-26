//
//  GKDashboard.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/17.
//

import SwiftUI
import GameKit

struct GKDashboardViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = GKGameCenterViewController

    var viewState: GKGameCenterViewControllerState = .dashboard
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = GKGameCenterViewController(state: viewState)
        viewController.setToolbarHidden(true, animated: true)
        viewController.gameCenterDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        var parent: GKDashboardViewController

        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated:true)
            
        }
        
        init(_ gkDashboardViewController: GKDashboardViewController) {
            self.parent = gkDashboardViewController
        }
    }
}
