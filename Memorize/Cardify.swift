//
//  Cardify.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/25.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape: RoundedRectangle = RoundedRectangle(cornerRadius: DrawingContants.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingContants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(isFaceUp ? 1.0 : 0.0)
        }
    }
    
    private struct DrawingContants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 3.0
    }
}
