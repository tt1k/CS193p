//
//  ContentView.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/8.
//

import SwiftUI

struct ContentView: View {
    var emojis: Array<String> = ["🚚", "🛵", "✈️", "🚀", "🚌",
                                 "🚗", "🚕", "🚙", "🚲", "🏍",
                                 "⛴", "🚢", "⛽️", "🚤", "🛥",
                                 "🚝", "🛸", "🚄", "🚅", "🚂",
    ]
    @State var emojiCount: Int = 20
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
        }
        .padding(.horizontal)
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        let shape: RoundedRectangle = RoundedRectangle(cornerRadius: 20.0)
        ZStack {
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3.0)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}
