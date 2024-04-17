//
//  ContentView.swift
//  Set
//
//  Created by MyBook on 08.02.2022.
//

import SwiftUI

struct SetGameView: View {
    typealias Card = SetGame.Card
    
    @ObservedObject var game: SetViewModelGame
    
    @State private var deals = Set<Int>()
    
    @Namespace private var dealingNamespace
    
    func deal(_ card: Card) {
        deals.insert(card.id)
    }
    
    func isDealt(_ card: Card) -> Bool {
        deals.contains(card.id)
    }
    
    func dealAnimation(_ card: Card) -> Animation {
        var delay = 0.0
        delay = Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0) * 0.2
        return Animation.easeInOut(duration: 0.5).delay(delay)
    }
    
    func zIndex(of card: Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    func allowScroll(cardsInDeck: Int, in geomerty: GeometryProxy) -> Bool {
        let heightCount = Int(geomerty.size.height / (UIScreen.screenWidth / 6) / (1/CardSettings.aspectCard))
        if heightCount * game.maxCardsInRow < cardsInDeck {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center) {
                tabBarMenu
                Spacer()
                gameBody
                Spacer()
                HStack {
                    cross
                    Spacer()
                    checkMark
                }
                .padding(.horizontal)
            }
            cardDeck
        }
    }
    var gameBody: some View {
        GeometryReader { geometry in
            AspectVGrid(
                items: Array(game.cards[0..<game.countCardsInDesk]),
                aspectRatio: CardSettings.aspectCard,
                scrollAvalible: allowScroll(cardsInDeck: game.countCardsInDesk, in: geometry),
                maxCardsInRow: game.maxCardsInRow) { card in
                if isDealt(card) {
                    CardView(card: card)
                        .zIndex(zIndex(of: card))
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: CardSettings.animationDuration)) {
                                game.choose(card)
                                deals = Set(game.cards[0..<game.countCardsInDesk].map { $0.id })
                            }
                        }
                } else {
                    Color.clear
                }
            }
        }
    }
    var cardDeck: some View {
        VStack {
            ZStack {
                ForEach(game.cards.filter({ !isDealt($0) })) { card in
                    CardView(card: card)
                        .zIndex(zIndex(of: card))
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                        .aspectRatio(CardSettings.aspectCard, contentMode: .fit)
                        .frame(width: CardSettings.deckWidth)
                }
            }
            if !game.cards.filter({ !isDealt($0) }).isEmpty {
                Text(String(game.cards.count - deals.count))
                    .foregroundColor(CardSettings.fillColor)
            }
        }
        .onTapGesture {
            if deals.isEmpty {
                for card in game.cards[0..<12] {
                    withAnimation(dealAnimation(card)) {
                        deal(card)
                    }
                }
            } else {
                game.addCards()
                withAnimation(.linear(duration: CardSettings.animationDuration)) {
                    deals = Set(game.cards[0..<game.countCardsInDesk].map { $0.id })
                }
            }
        }
    }
    var tabBarMenu: some View {
        HStack {
            Spacer()
            Text("Set")
                .font(.largeTitle)
                .bold()
            Spacer()
            Image(systemName: "arrow.counterclockwise")
                .font(.largeTitle)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: CardSettings.animationDuration)) {
                        deals = []
                    }
                    game.resetGame()
                }
        }
        .padding(.horizontal)
    }
    var cross: some View {
        VStack {
            Cross()
                .stroke(lineWidth: CardSettings.strokeWidth)
                .aspectRatio(1/1, contentMode: .fit)
                .frame(width: CardSettings.menuWidth)
            Text(game.redPointCount)
        }
        .foregroundColor(.red)
    }
    var checkMark: some View {
        VStack {
            CheckMark()
                .stroke(lineWidth: CardSettings.strokeWidth)
                .aspectRatio(1/1, contentMode: .fit)
                .frame(width: CardSettings.menuWidth)
            Text(game.greenPointCount)
        }
        .foregroundColor(.green)
    }
    
    private struct CardSettings {
        static let aspectShape: CGFloat = 2/1
        static let menuWidth: CGFloat = 40
        static let deckWidth: CGFloat = 60
        static let strokeWidth: CGFloat = 3
        static let animationDuration: CGFloat = 0.2
        static let aspectCard: CGFloat = 2/3
        static let fillColor: Color = .yellow
    }
}

struct CardView: View {
    typealias Card = SetGame.Card
    var card: Card
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0..<card.numberShape, id: \.self) { _ in
                    createShape(card)
                        .aspectRatio(CardSettings.aspectShape, contentMode: .fit)
                        .foregroundColor(card.color)
                        .padding(.horizontal, 5)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .background(
                RippleEffect(isSelected: card.isSelected)
                    .foregroundColor(.yellow)
                    .clipped()
            )
            .background(Color.init(white: CardSettings.backgroundSaturation))
        }
        .padding(5)
        .cornerRadius(CardSettings.cornerRadius)
        .shadow(color: .init(white: CardSettings.shadowSaturation), radius: 1, x: 0, y: 1)
    }
    
    private struct CardSettings {
        static let aspectShape: CGFloat = 2/1
        static let cornerRadius: CGFloat = 20
        static let shadowSaturation: CGFloat = 0.5
        static let backgroundSaturation: CGFloat = 0.9
        static let strokeWidth: CGFloat = 3
    }
    
    @ViewBuilder
    private func createShape(_ card: Card) -> some View {
        let isAddStripes = card.coloring == .stripe ? true : false
        switch card.shape {
        case .rhombus:
            coloring(card, shape: Rhombus(isAddStripes: isAddStripes))
        case .oval:
            coloring(card, shape: Oval(isAddStripes: isAddStripes))
        case .wave:
            coloring(card, shape: Wave(isAddStripes: isAddStripes))
        }
    }
    
    @ViewBuilder
    private func coloring<T: Shape>(_ card: Card, shape: T) -> some View {
        switch card.coloring {
        case .fill:
            shape
        case .stroke:
            shape
                .stroke(lineWidth: CardSettings.strokeWidth)
        case .stripe:
            shape
                .stroke(lineWidth: CardSettings.strokeWidth)
                .clipShape(shape)
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetViewModelGame()
        SetGameView(game: game)
    }
}


extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
//
//extension View {
//    func getSize(sizee: () -> CGSize) {
//        GeometryReader { geometry in
//            self
//            sizee {
//                return geometry.size
//            }
//        }
//    }
//}
