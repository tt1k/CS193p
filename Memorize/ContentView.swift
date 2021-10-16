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
            Spacer(minLength: 20.0)
            HStack {
                addBtnView
                Spacer()
                removeBtnView
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var addBtnView: some View {
        Button(action: {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        }, label: {
            Image(systemName: "plus.circle")
        })
    }
    
    var removeBtnView: some View {
        Button(action: {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        }, label: {
            Image(systemName: "minus.circle")
        })
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
