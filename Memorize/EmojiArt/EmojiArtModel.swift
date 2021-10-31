//
//  EmojiArtModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/31.
//

import SwiftUI

struct EmojiArtModel {
    var background = Background.blank
    var emojis = [Emoji]()
        
    struct Emoji: Identifiable, Hashable {
        let id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        /// only anyone inside this file can use this init method
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y:Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
}
