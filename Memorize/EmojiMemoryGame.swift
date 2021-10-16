//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/16.
//

import SwiftUI

class EmojiMemoryGame {
    
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
    
    private(set) var model: MemoryGameModel<String> = createMemoryGame()
    
    var cards: Array<MemoryGameModel<String>.Card> {
        return model.cards
    }
    
}
