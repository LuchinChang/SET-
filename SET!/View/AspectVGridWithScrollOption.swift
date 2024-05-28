//
//  AspectVGrid.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/23.
//

import SwiftUI

struct AspectVGridWithScrollOption<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1
    let content: (Item) -> ItemView
    let minimumSizeForVGrid: CGFloat
    
    init(_ items: [Item], aspectRatio: CGFloat, minimumSizeForVGrid: CGFloat = 70, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
        self.minimumSizeForVGrid = minimumSizeForVGrid
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let gridItemSize = max(minimumSizeForVGrid, gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            ))
            
            let grid = LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
            
            if gridItemSize == minimumSizeForVGrid {
                ScrollView { grid }
            } else {
                grid
            }
        }
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
