//
//  SET_App.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

@main
struct SET_App: App {
    var body: some Scene {
        WindowGroup {
//            @StateObject var shapeSetGamee = ShapeSetGame()
            
            ShapeSetGameView(ShapeSetGame())
//                .environmentObject(ShapeSetGame())
        }
    }
}
