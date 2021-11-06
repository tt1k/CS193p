//
//  Cardify.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/25.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0.0 : 180.0
    }
    
    var rotation: Double
    
    /// protocal Animatable var
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape: RoundedRectangle = RoundedRectangle(cornerRadius: DrawingContants.cornerRadius)
            if rotation < 90.0 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingContants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90.0 ? 1.0 : 0.0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingContants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 3.0
    }
}
