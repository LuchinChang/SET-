//
//  SwiftUIView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/4/22.
//

import SwiftUI

struct CardView: View {
    @State private var isSelected = false
    @State private var isMatched: Bool? = true

    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12).fill(.white)
            let symbol = SymbolView(number: 3, shading: SymbolShading.solid, color: .blue, shape: Ellipse())

            Group {
                base.strokeBorder(lineWidth: isSelected ? 4 : 2)
                symbol
                
                if isSelected, let isMatched {
                    matchedView(isMatched)
                }
            }
            .onTapGesture {
                isSelected.toggle()
            }
        }
    }
    
    func matchedView(_ isMatched: Bool) -> some View {
        let indicator = isMatched ? "✓" : "X"
        return Text(indicator)
            .foregroundStyle(isMatched ? .green : .red)
            .font(.system(size: 200))
            .minimumScaleFactor(0.01)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct SymbolView<S: Shape>: View {
    let number: Int
    let shading: SymbolShading
    let color: Color
    let shape: S
    
    let aspectRatio: Double = 5/1
    let widthPortion: Double = 0.8
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            VStack(spacing:10) {
                ForEach (0..<number, id:\.self) { _ in
                    shape
                        .fill(color)
                        .stroke(color, lineWidth: 0)
                        .opacity(shading == SymbolShading.semiTransparent ? 0.3 : 1)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .frame(width: width * widthPortion)
                }
            }
            .frame(width: width, height: height)
        }
    }
}
