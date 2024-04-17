//
//  extensionShape.swift
//  Set
//
//  Created by MyBook on 09.02.2022.
//

import SwiftUI

extension Path {
    mutating func addStripes(in rect: CGRect, count: Int = 10) {
        let step = rect.width / CGFloat(count + 1)
        for i in 1...count {
            self.move(to: CGPoint(
                x: rect.minX + step * CGFloat(i),
                y: rect.minY)
            )
            self.addLine(to: CGPoint(
                x: rect.minX + step * CGFloat(i),
                y: rect.maxY)
            )
        }
    }
}
