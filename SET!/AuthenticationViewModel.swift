//
//  AuthenticationViewModel.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/3.
//

import Foundation
import Combine
import GameKit
import GameKitUI

class AuthenticationViewModel: ObservableObject {

    @Published public var showModal = false
    @Published public var showAlert = false
    @Published public var isAuthenticated = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    @Published public var currentState: String = "Loading GameKit..."
    @Published public var player: GKPlayer? {
        didSet {
            self.isAuthenticated = self.player != nil
        }
    }
    
    func load() {
        if self.isAuthenticated {
            return
        }
        self.showAuthenticationModal()
    }

    func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
    
    func showAuthenticationModal() {
        self.showModal = true
    }
}

