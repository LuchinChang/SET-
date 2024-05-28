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

struct Diamond: Shape {
    var widthRatio: CGFloat = 1.0 // Controls the horizontal compression
    var heightRatio: CGFloat = 1.0 // Controls the vertical compression
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
                
        // Calculate key points based on width and height ratios
        let horizontalAdjustment = (1.0 - widthRatio) * rect.width / 2
        let verticalAdjustment = (1.0 - heightRatio) * rect.height / 2
        
        let top = CGPoint(x: rect.midX, y: rect.minY + verticalAdjustment)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY - verticalAdjustment)
        let left = CGPoint(x: rect.minX + horizontalAdjustment, y: rect.midY)
        let right = CGPoint(x: rect.maxX - horizontalAdjustment, y: rect.midY)
        
        path.move(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        path.closeSubpath()
        
        return path
    }
}

