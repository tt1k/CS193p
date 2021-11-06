//
//  MemoryGameViewModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/16.
//

import SwiftUI

/// ViewModel
class MemoryGameViewModel: ObservableObject {
    typealias Card = MemoryGameModel<String>.Card
    
    /// type variable
    private static let emojis = ["🚚", "🛵", "✈️", "🚀", "🚌", "🚗", "🚕", "🚙", "🚲", "🏍",
                                 "⛴", "🚢", "⛽️", "🚤", "🛥", "🚝", "🛸", "🚄", "🚅", "🚂"]

    /// type function
    private static func createMemoryGameViewModel() -> MemoryGameModel<String> {
        MemoryGameModel<String>(numberOfPairsOfCards: 10) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    /// @Published makes objectWillChange.send() happen
    @Published private(set) var model = createMemoryGameViewModel()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: Intent Functions
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = MemoryGameViewModel.createMemoryGameViewModel()
    }
}
