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
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(.red)
        }
        .padding(.horizontal)
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
        static let cornerRadius: CGFloat = 20.0
        static let lineWidth: CGFloat = 3.0
        static let fontScale: CGFloat = 0.8
        static let clearOpacity: CGFloat = 0.0
    }
}
