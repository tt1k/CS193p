//
//  MemoryGameView.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/8.
//

import SwiftUI

/// View
struct MemoryGameView: View {
    /// @ObservedObject means that when something changed, please rebuild this body
    @ObservedObject var viewModel: MemoryGameViewModel
    
    var body: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3, content: { card in
            cardView(for: card)
        })
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func cardView(for card: MemoryGameViewModel.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0.0)
        } else {
            CardView(card: card)
                .padding(4.0)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
}

struct CardView: View {
    let card: MemoryGameViewModel.Card
    
    var body: some View {
        GeometryReader(content: { geometry in
            let shape: RoundedRectangle = RoundedRectangle(cornerRadius: DrawingContants.cornerRadius)
            let size: CGFloat = DrawingContants.fontScale * min(geometry.size.width, geometry.size.height)
            ZStack {
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingContants.lineWidth)
                    Pie(startAngle: Angle(degrees: -90.0), endAngle: Angle(degrees: 45.0))
                        .padding(5.0)
                        .opacity(0.5)
                    Text(card.content).font(.system(size: size))
                } else if card.isMatched {
                    shape.opacity(DrawingContants.clearOpacity)
                } else {
                    shape.fill()
                }
            }
        })
    }
    
    private struct DrawingContants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 3.0
        static let fontScale: CGFloat = 0.6
        static let clearOpacity: CGFloat = 0.0
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        game.choose(game.cards.first!)
        return MemoryGameView(viewModel: game)
    }
}
