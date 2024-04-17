//
//  CardSelectEffect.swift
//  Set
//
//  Created by MyBook on 25.02.2022.
//

import Foundation
import SwiftUI

struct RippleEffect: Shape {
    var endXCoefficient: CGFloat
    var animatableData: CGFloat {
        get { endXCoefficient }
        set { endXCoefficient = newValue }
    }
    init(isSelected: Bool) {
        endXCoefficient = isSelected ? 1 : 0
    }
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let startPoint1 = rect.origin
        let startPoint2 = CGPoint(x: rect.origin.x - rect.size.width/2, y: rect.maxY)
        p.move(to: startPoint1)
        p.addLine(to: startPoint2)
        p.addLine(to: CGPoint(x: endXCoefficient * rect.width, y: rect.maxY))
        p.addLine(to: CGPoint(x: endXCoefficient * (rect.width + rect.size.width/2), y: rect.minX))
        p.addLine(to: startPoint1)
        return p
    }
}
