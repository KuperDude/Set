//
//  Cross.swift
//  Set
//
//  Created by MyBook on 13.02.2022.
//

import SwiftUI

struct Cross: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: rect.origin)
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return p
    }
}
