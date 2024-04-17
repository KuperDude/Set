//
//  ReloadArrow.swift
//  Set
//
//  Created by MyBook on 14.02.2022.
//

import SwiftUI

struct ReloadArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: min(rect.height, rect.width)/2,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 225),
            clockwise: true
        )
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        return p
    }
}
