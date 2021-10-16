//
//  MemoryGameModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/16.
//

import Foundation

struct MemoryGameModel<CardContent> {
    private(set) var cards: Array<Card>
    
    func choose(_ card: Card) {
        
    }
    
    /// passing a function as a parameter
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
        }
    }

    /// Card structure
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
