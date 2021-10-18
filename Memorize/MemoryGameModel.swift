//
//  MemoryGameModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/16.
//

import Foundation

/// Model
struct MemoryGameModel<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOnlyFaceUpCard: Int?
    
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
                indexOfTheOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    /// passing a function as a parameter
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }

    /// Card structure
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
