//
//  EmojiArtModel.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/31.
//

import SwiftUI

struct EmojiArtModel: Codable {
    var background = Background.blank
    var emojis = [Emoji]()
        
    struct Emoji: Identifiable, Hashable, Codable {
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
    
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try EmojiArtModel(json: data)
    }
    
    init() {
        
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y:Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: uniqueEmojiId))
    }
}
