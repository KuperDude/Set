//
//  Oval.swift
//  Set
//
//  Created by MyBook on 08.02.2022.
//

import SwiftUI

struct Oval: Shape {
    var isAddStripes: Bool
    init(isAddStripes: Bool = false) {
        self.isAddStripes = isAddStripes
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addEllipse(in: CGRect(
            origin: CGPoint(x: 0, y: (rect.height - (rect.height / 1.5)) / 2),
            size: CGSize(width: rect.width, height: rect.height / 1.5))
        )
        if isAddStripes {
            p.addStripes(in: rect, count: 10)
        }
        return p
    }
}
