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
    let minSizeForVGrid: CGFloat
    let maxSizeForVGrid: CGFloat
    
    
    init(_ items: [Item], aspectRatio: CGFloat, minSizeForVGrid: CGFloat = 70, maxSizeForVGrid: CGFloat = 90, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
        self.minSizeForVGrid = minSizeForVGrid
        self.maxSizeForVGrid = maxSizeForVGrid
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            var gridItemSize: CGFloat {
                let gridItemWidthThatFits = gridItemWidthThatFits(
                    count: items.count,
                    size: geometry.size,
                    atAspectRatio: aspectRatio
                )
                
                if gridItemWidthThatFits > maxSizeForVGrid {
                    return maxSizeForVGrid
                } else if gridItemWidthThatFits < minSizeForVGrid {
                    return minSizeForVGrid
                } else {
                    return gridItemWidthThatFits
                }
            }
            
            let grid = LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
            
            if gridItemSize == minSizeForVGrid {
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
