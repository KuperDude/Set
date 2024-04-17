//
//  SetViewModelGame.swift
//  Set
//
//  Created by MyBook on 10.02.2022.
//

import Foundation

class SetViewModelGame: ObservableObject {
    @Published private var model = SetGame()
    
    var cards: Array<SetGame.Card> {
        return model.cards
    }
    var countCardsInDesk: Int {
        return model.countCardsInDesk
    }
    var redPointCount: String {
        return String(model.redPointCount)
    }
    var greenPointCount: String {
        return String(model.greenPointCount)
    }
    var maxCardsInRow: Int {
        return model.maxCardsInRow
    }
    
    //MARK: - Intent(s)
    func choose(_ card: SetGame.Card) {
        model.choose(card)
    }
    func addCards() {
        model.addCards()
    }
    func resetGame() {
        model = SetGame()
    }
}
