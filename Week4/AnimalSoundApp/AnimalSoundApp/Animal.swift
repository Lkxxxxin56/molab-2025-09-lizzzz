import SwiftUI

struct Animal: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let symbol: String   // SF Symbol name
    let soundFile: String // must exist in app bundle
}

let pets: [Animal] = [
    .init(name: "Cat",     symbol: "cat.circle.fill", soundFile: "cat-meow.mp3"),
    .init(name: "Dog",     symbol: "dog.circle.fill",      soundFile: "dog-bark.mp3"),
    .init(name: "Parrot",  symbol: "bird.circle.fill",          soundFile: "bird-sing.mp3"),
    .init(name: "Goldfish",symbol: "fish.circle.fill",          soundFile: "fish-bubble.mp3"),
    .init(name: "Rabbit",    symbol: "hare.circle.fill",          soundFile: "rabbit-sounds.mp3"),
]
