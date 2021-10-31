//
//  MemorizeApp.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/8.
//

import SwiftUI

@main
struct MemorizeApp: App {
//    private let game = MemoryGameViewModel()
    private let document = EmojiArtDocumentViewModel()
    
    var body: some Scene {
        WindowGroup {
//            MemoryGameView(viewModel: game)
//                .preferredColorScheme(.light)
            EmojiArtDocumentView(document: document)
        }
    }
}
