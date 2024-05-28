//
//  GameKitHelper.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/27.
//

import GameKit

class GameKitHelper: NSObject {
    
    // Shared GameKit Helper
    static let shared: GameKitHelper = {
        let instance = GameKitHelper()
        
        return instance
    }()
    
    var authenticationViewController: UIViewController?
    
    // MARK: - GAME CENTER METHODS
    func authenticationLocalPlayer() {
        
        // Prepare for new controller
        authenticationViewController = nil
        
        // Authenticate local player
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            
            if let viewController {
                // Present the view controller so the player can sign in
                self.authenticationViewController = viewController
                NotificationCenter.default.post(
                    name: .presentAuthenticationViewController,
                    object: self)
                return
            }
            
            if error != nil {
                return
            }
        }
    }
}

extension Notification.Name {
    static let presentAuthenticationViewController = Notification.Name("presentAuthenticationViewController")
    
 
    
    
    
    
}
