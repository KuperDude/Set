//
//  Rhombus.swift
//  Set
//
//  Created by MyBook on 08.02.2022.
//

import SwiftUI

struct Rhombus: Shape {
    var isAddStripes: Bool
    init(isAddStripes: Bool = false) {
        self.isAddStripes = isAddStripes
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 5))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - 5))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        if isAddStripes {
            p.addStripes(in: rect, count: 10)
        }
        return p
    }
}
