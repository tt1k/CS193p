//
//  MemoryGameViewModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/16.
//

import SwiftUI

/// ViewModel
class MemoryGameViewModel: ObservableObject {
    
    /// type variable
    static let emojis: Array<String> = ["🚚", "🛵", "✈️", "🚀", "🚌",
                                        "🚗", "🚕", "🚙", "🚲", "🏍",
                                        "⛴", "🚢", "⛽️", "🚤", "🛥",
                                        "🚝", "🛸", "🚄", "🚅", "🚂"]

    /// type function
    static func createMemoryGame() -> MemoryGameModel<String> {
        MemoryGameModel<String>(numberOfPairsOfCards: 10) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    /// @Published makes objectWillChange.send() happen
    @Published private(set) var model: MemoryGameModel<String> = createMemoryGame()
    
    var cards: Array<MemoryGameModel<String>.Card> {
        return model.cards
    }
    
    func choose(_ card: MemoryGameModel<String>.Card) {
        model.choose(card)
    }
    
}
