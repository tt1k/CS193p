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
            ZStack {
                Pie(startAngle: Angle(degrees: -90.0), endAngle: Angle(degrees: 45.0))
                    .padding(DrawingContants.piePadding)
                    .opacity(DrawingContants.pieOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360.0 : 0.0))
                    .animation(Animation.linear(duration: DrawingContants.aniDuration)
                    .repeatForever(autoreverses: false))
                    .font(.system(size: DrawingContants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    /// fix animation bug when rotating device
    private func scale(thatFits size:CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingContants.fontSize / DrawingContants.fontScale)
    }
    
    private struct DrawingContants {
        static let piePadding = 5.0
        static let pieOpacity = 0.5
        
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 32.0
        
        static let aniDuration: CGFloat = 1.0
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        game.choose(game.cards.first!)
        return MemoryGameView(viewModel: game)
    }
}
