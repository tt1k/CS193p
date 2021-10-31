//
//  EmojiArtDocumentView.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/31.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocumentViewModel
    
    let defaultEmojiFontSize: CGFloat  = 40.0
    let emojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
    
    var body: some View {
        VStack(spacing: 0.0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                ForEach(document.emojis) { emoji in
                    Text(emoji.text)
                        .font(.system(size: fontSize(of: emoji)))
                        .position(position(of: emoji, in: geometry))
                }
            }
            .onDrop(of: [.plainText], isTargeted: nil) { providers, location in
                drop(providers: providers, location: location, in: geometry)
            }
        }

    }
    
    var palette: some View {
        ScrollingEmojiView(emojis: emojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    private func fontSize(of emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func position(of emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    /// calculate where the emoji should be
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x),
            y: center.y + CGFloat(location.y)
        )
    }
    
    /// calculate where user drop the emoji
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: location.x - center.x,
            y: location.y - center.y
        )
        return (x: Int(location.x), y: Int(location.y))
    }
    
    /// handle user droping an emoji
    private func drop(providers: [NSItemProvider], location: CGPoint, in geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self) { string in
            if let emoji = string.first, emoji.isEmoji {
                document.addEmoji(
                    String(string),
                    at: convertToEmojiCoordinates(location, in: geometry),
                    size: defaultEmojiFontSize)
            }
        }
    }
}

struct ScrollingEmojiView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct EmojiArtDocumentViewPreview: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocumentViewModel())
    }
}
