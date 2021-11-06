//
//  EmojiArtDocument.swift
//  Memorize
//
//  Created by FakeCoder on 2021/10/31.
//

import SwiftUI
import Combine

class EmojiArtDocumentViewModel: ObservableObject {
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            scheduleAutosave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private var autosaveTimer: Timer?
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            self.autosave()
        }
    }
    
    private struct Autosave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
        static let coalescingInterval = 2.0
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data =  try emojiArt.json()
            print("\(thisFunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
            print("\(thisFunction) success!")
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }
    
    init() {
        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackgroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
        }
        emojiArt.addEmoji("🐶", at: (-200, -100), size: 80)
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    
    var background: EmojiArtModel.Background { emojiArt.background }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    private var backgroundImageFetchCencellable: AnyCancellable?
    
    enum BackgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
            case .url(let url):
                /// fetch the url
                backgroundImageFetchStatus = .fetching
                backgroundImageFetchCencellable?.cancel()
                let session = URLSession.shared
                let publisher = session.dataTaskPublisher(for: url)
                    .map { (data, urlResponse) in UIImage(data: data) }
                    .replaceError(with: nil)
                    .receive(on: DispatchQueue.main)
                
                backgroundImageFetchCencellable = publisher
                    .sink { [weak self] image in
                        self?.backgroundImageFetchStatus = image == nil ? .failed(url) : .idle
                        self?.backgroundImage = image
                    }

                /// old way to fetch image
//                DispatchQueue.global(qos: .userInitiated).async {
//                    let imageData = try? Data(contentsOf: url)
//                    DispatchQueue.main.async { [weak self] in
//                        if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
//                            self?.backgroundImageFetchStatus = .idle
//                            if imageData != nil {
//                                self?.backgroundImage = UIImage(data: imageData!)
//                            }
//                            if self?.backgroundImage == nil {
//                                self?.backgroundImageFetchStatus = .failed(url)
//                            }
//                        }
//                    }
//                }
            case .imageData(let data):
                backgroundImage = UIImage(data: data)
            case .blank:
                break
        }
    }
    
    // MARK: Intent
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
