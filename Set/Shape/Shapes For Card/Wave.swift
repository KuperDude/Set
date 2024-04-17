//
//  Wave.swift
//  Set
//
//  Created by MyBook on 08.02.2022.
//

import SwiftUI

struct Wave: Shape {
    var isAddStripes: Bool
    init(isAddStripes: Bool = false) {
        self.isAddStripes = isAddStripes
    }
    
    func path(in rect: CGRect) -> Path {
        let startPoint = CGPoint(x: rect.minX, y: rect.midY/2)
        var p = Path()
        p.move(to: startPoint)
        
        //up wave
        p.addCurve(
            to: CGPoint(x: rect.midX, y: rect.midY/2),
            control1: CGPoint(x: rect.minX + rect.midX / 2, y: 0),
            control2: CGPoint(x: rect.midX, y: rect.midY/2)
        )
        p.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY/2),
            control1: CGPoint(x: rect.midX + rect.midX / 2, y: rect.maxY/2),
            control2: CGPoint(x: rect.maxX, y: rect.midY/2)
        )
        
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + rect.midY/2))
        
        //down wave
        p.addCurve(
            to: CGPoint(x: rect.midX, y: rect.midY + rect.midY/2),
            control1: CGPoint(x: rect.midX + rect.midX / 2, y: rect.maxY),
            control2: CGPoint(x: rect.midX, y: rect.midY + rect.midY/2)
        )
        p.addCurve(
            to: CGPoint(x: rect.minX, y: rect.midY + rect.midY/2),
            control1: CGPoint(x: rect.minX + rect.midX / 2, y: rect.minY + rect.midY),
            control2: CGPoint(x: rect.minX, y: rect.midY + rect.midY/2)
        )
        p.addLine(to: startPoint)
        if isAddStripes {
            p.addStripes(in: rect, count: 10)
        }        
        return p
    }
}

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        Wave()
            .stroke(lineWidth: 2)
            .foregroundColor(.red)
            .frame(width: 200, height: 100, alignment: .center)
    }
}
