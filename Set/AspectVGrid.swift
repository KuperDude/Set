//
//  AspectVGrid.swift
//  Memorize
//
//  Created by MyBook on 07.02.2022.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    var scrollAvalible: Bool
    var maxCardsInRow: Int
    
    init(items: [Item], aspectRatio: CGFloat, scrollAvalible: Bool = false, maxCardsInRow: Int = 6, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
        self.scrollAvalible = scrollAvalible
        self.maxCardsInRow = maxCardsInRow
    }
    
    var body: some View {
        if scrollAvalible {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                        LazyVGrid(columns: [adaptiveGriditem(width: width)], spacing: 0) {
                            ForEach(items, id: \.id) { item in
                                content(item).aspectRatio(aspectRatio, contentMode: .fit)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                }
            }
        } else {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                    LazyVGrid(columns: [adaptiveGriditem(width: width)], spacing: 0) {
                        ForEach(items, id: \.id) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    private func adaptiveGriditem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        var itemHeight: CGFloat = 0
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
            if columnCount > itemCount {
                columnCount = itemCount
        }
        if columnCount > maxCardsInRow {
            columnCount = maxCardsInRow
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
