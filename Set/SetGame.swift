//
//  SetGame.swift
//  Set
//
//  Created by MyBook on 09.02.2022.
//

import SwiftUI

struct SetGame {
    var cards: [Card] = []
    var countCardsInDesk = 12
    var greenPointCount = 0
    var redPointCount = 0
    var maxCardsInRow = 6
    
    init() {        
        fillCards()
    }
    
    private mutating func fillCards() {
        let colors: [Color] = [.green, .red, .purple]
        var id = 0
        
        for i in 1...3 {
            for shape in IdShape.allCases {
                for coloring in СoloringShape.allCases {
                    for color in colors {
                        cards.append(Card(
                            id: id,
                            shape: shape,
                            numberShape: i,
                            coloring: coloring,
                            color: color)
                        )
                        id += 1
                    }
                }
            }
        }
        cards.shuffle()
    }
    var selectedCards: [Card] {
        get { cards.filter { $0.isSelected } }
        set {
            cards.indices.forEach({ cards[$0].isSelected = false; cards[$0].isSet = false })
            for i in cards.indices {
                for card in newValue {
                    if card.id == cards[i].id {
                        if newValue.count != 3 {
                            cards[i].isSelected = true
                        } else {
                            cards[i].isSet = true
                        }
                        continue
                    }
                }
            }
        }
    }
    mutating func addCards() {
        if countCardsInDesk != cards.count {
            countCardsInDesk += 3
        }
    }
    
    mutating func choose(_ card: Card) {
        if !selectedCards.contains(card) {
            selectedCards.append(card)
            let cardSet = cards.filter({ $0.isSet })
            if cardSet.count == 3 {
                if examinationSet(cardSet) {
                    greenPointCount += 3
                } else {
                    redPointCount += 3
                }
                selectedCards = []
            }
        } else {
            cards.indices.forEach {
                if cards[$0].id == card.id {
                    cards[$0].isSelected = false
                }
            }
        }
        
    }
    
    private mutating func examinationSet(_ set: [Card]) -> Bool {
        let shapes   = set.map({ $0.shape })
        let colors   = set.map({ $0.color })
        let coloring = set.map({ $0.coloring })
        let numbers  = set.map({ $0.numberShape })
        
        func setForArray<T: Hashable>(_ array: Array<T>) -> Bool {
            if array.uniqued().count == 3 || array.uniqued().count == 1 {
                return true
            }
            return false
        }
        removeCards(set)
        
        if setForArray(shapes) && setForArray(colors) && setForArray(coloring) && setForArray(numbers) {
            return true
        }
        return false
    }
    
    mutating func removeCards(_ set: [Card]) {
        for value in set {
            for (i, card) in cards.enumerated() {
                if card.id == value.id {
                    cards.remove(at: i)
                    continue
                }
            }
        }
        if countCardsInDesk > 12 {
            countCardsInDesk -= 3
        } else if cards.count < 12 {
            countCardsInDesk -= 3
        }
    }
    
    struct Card: Equatable, Identifiable, Hashable {
        var id: Int
        var shape: IdShape
        var numberShape: Int
        var coloring: СoloringShape
        var color: Color
        var isSet: Bool = false
        var isSelected: Bool = false
    }
    enum СoloringShape: CaseIterable {
        case fill
        case stripe
        case stroke
    }
    enum IdShape: CaseIterable {
        case oval
        case rhombus
        case wave
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
