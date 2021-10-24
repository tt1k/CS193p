//
//  MemoryGameModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/16.
//

import Foundation

/// Extension
extension Array {
    var oneAndOnly: Element? {
        if 1 == count {
            return first
        } else {
            return nil
        }
    }
}

/// Model
struct MemoryGameModel<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach({ cards[$0].isFaceUp = ($0 == newValue) }) }
    }
    
    /// mutating means this function can change things in this struct
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchCard = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchCard].content {
                    cards[potentialMatchCard].isMatched = true
                    cards[chosenIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    /// passing a function as a parameter
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }

    /// Card structure
    struct Card: Identifiable {
        let id: Int
        
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
    }
}
