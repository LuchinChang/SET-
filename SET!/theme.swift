//
//  theme.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import Foundation

struct Theme<feat1, feat2, feat3, feat4> {
    let feat1Factory: (Int) -> feat1
    let feat2Factory: (Int) -> feat2
    let feat3Factory: (Int) -> feat3
    let feat4Factory: (Int) -> feat4
}
