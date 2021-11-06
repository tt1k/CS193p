//
//  Pie.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/24.
//

import SwiftUI

struct Pie: Shape {
    /// these variables are going to vary during the animation
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = true
    
    /// protocal Animatable va
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        path.addLine(to: center)
        
        return path
    }
    
}
