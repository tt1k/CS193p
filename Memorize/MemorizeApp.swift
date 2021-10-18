//
//  MemorizeApp.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/8.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = MemoryGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            MemoryGameView(viewModel: game)
                .preferredColorScheme(.light)
        }
    }
}
