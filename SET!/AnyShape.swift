//
//  AnyShape.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/29.
//

import SwiftUI

struct AnyShape: Shape {
    private let pathClosure: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) where S: Sendable {
        self.pathClosure = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathClosure(rect)
    }
}
