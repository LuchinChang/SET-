//
//  DebugHelper.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/26.
//

import Foundation

enum DebugHelper {
    static func printInfo(_ info: Any...) {
        #if DEBUG
        print(info)
        #endif
    }
}
