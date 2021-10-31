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
    
    /// for matchedGeometryEffect
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restartBtn
                    Spacer()
                    shuffleBtn
                }
            }
            /// position deckBody on different zIndex level
            /// so gameBody do not need to share space with deckBody
            deckBody
        }
        .padding(.horizontal)
    }
    
    /// is dealt or not mark for each card
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: MemoryGameViewModel.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: MemoryGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    /// animation for each card when placing them
    private func dealAnimation(for card: MemoryGameViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = viewModel.cards.firstIndex(where: { $0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDuration / Double(viewModel.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    /// make the top card get distributed first
    private func zIndex(of card: MemoryGameViewModel.Card) -> Double {
        -Double(viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }

    var gameBody: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: CardConstants.aspectRatio, content: { card in
            cardView(for: card)
        })
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter(isUnDealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .onTapGesture {
            for card in viewModel.cards {
                /// add easeInOut effects when cards first appears
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
    }
    
    var shuffleBtn: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 2.0)) {
                viewModel.shuffle()
            }
        }
    }
    
    var restartBtn: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                viewModel.restart()
            }
        }
    }

    @ViewBuilder
    private func cardView(for card: MemoryGameViewModel.Card) -> some View {
        if (card.isMatched && !card.isFaceUp) || isUnDealt(card) {
            /// Color.clear can do the same trick here
            Rectangle().opacity(0.0)
        } else {
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4.0)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(of: card))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                        viewModel.choose(card)
                    }
                }
        }
    }
        
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let undealtHeight: CGFloat = 90.0
        static let undealtWidth: CGFloat = undealtHeight * aspectRatio
        static let dealDuration: CGFloat = 0.5
        static let totalDuration: CGFloat = 3.0
    }
}

struct CardView: View {
    let card: MemoryGameViewModel.Card
    
    @State private var animatedBonusRemaining: Double = 0.0
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: -90.0),
                            endAngle: Angle(degrees: -90 + (1.0 - animatedBonusRemaining) * 360.0))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0.0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: -90.0),
                            endAngle: Angle(degrees: -90 + (1.0 - card.bonusRemaining) * 360.0))
                    }
                }
                    .padding(DrawingConstants.piePadding)
                    .opacity(DrawingConstants.pieOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360.0 : 0.0))
                    .animation(Animation.linear(duration: DrawingConstants.aniDuration)
                    .repeatForever(autoreverses: false))
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    /// fix animation bug when rotating device
    private func scale(thatFits size:CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
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

struct MemoryGameViewPreview: PreviewProvider {
    static var previews: some View {
        let game = MemoryGameViewModel()
        game.choose(game.cards.first!)
        return MemoryGameView(viewModel: game)
    }
}
