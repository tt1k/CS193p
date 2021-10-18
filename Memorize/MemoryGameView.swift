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
    let card: MemoryGameModel<String>.Card
    
    var body: some View {
        let shape: RoundedRectangle = RoundedRectangle(cornerRadius: 20.0)
        ZStack {
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3.0)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}
