//
//  MemorizeApp.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/8.
//

import SwiftUI

//@main
//struct MemorizeApp: App {
//    @StateObject var document = EmojiArtDocumentViewModel()
//    @StateObject var paletteStore = PaletteStore(named: "Default")
//
//    var body: some Scene {
//        WindowGroup {
//            EmojiArtDocumentView(document: document)
//                .environmentObject(paletteStore)
//        }
//    }
//}

@main
struct MemorizeApp: App {
    enum AppMode: Equatable {
        case MemorizeAppMode
        case EmojiArtAppMode
    }
    
    /// switch this mode to get in different app
    private let appMode:AppMode = .EmojiArtAppMode
    
    /// memorize vars
    private let game = MemoryGameViewModel()
    
    /// emojiart vars
    @StateObject var document = EmojiArtDocumentViewModel()
    @StateObject var paletteStore = PaletteStore(named: "Default")

    var body: some Scene {
        WindowGroup {
            if appMode == .MemorizeAppMode {
                MemoryGameView(viewModel: game)
                    .preferredColorScheme(.light)
            }
            if appMode == .EmojiArtAppMode {
                EmojiArtDocumentView(document: document)
                    .environmentObject(paletteStore)
            }
        }
    }
}
