import SwiftUI
import AVFoundation

struct HearGuessView: View {
    @State private var player: AVAudioPlayer? = nil

    // quiz state
    @State private var correct: Animal = pets[0]
    @State private var options: [Animal] = Array(pets.prefix(3)) // will set properly on appear
    @State private var score = 0
    @State private var rounds = 0
    private let totalRounds = 5

    var body: some View {
        VStack(spacing: 16) {
            Text("Hear → Guess")
                .font(.title.bold())

            Text("Round \(min(rounds + 1, totalRounds)) of \(totalRounds)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                playSound(correct.soundFile)
            } label: {
                Label("Play Sound", systemImage: "play.circle.fill")
                    .font(.title3.bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.thinMaterial, in: Capsule())
            }

            VStack(spacing: 12) {
                ForEach(options) { animal in
                    Button {
                        handleGuess(animal)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: animal.symbol)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text(animal.name).font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            Text("Score: \(score)")
                .font(.headline)
        }
        .padding(.top, 16)
        .onAppear { newRound() }
    }

    private func handleGuess(_ choice: Animal) {
        if choice == correct { score += 1 }
        rounds += 1
        if rounds >= totalRounds {
            // simple end: reset a new game
            rounds = 0
            score = 0
        }
        newRound()
    }

    private func newRound() {
        // pick a correct answer
        correct = pets.randomElement()!
        // pick two other unique options
        var pool = pets.shuffled().filter { $0 != correct }
        let others = Array(pool.prefix(2))
        options = ([correct] + others).shuffled()
        // auto-play sound each new round (optional):
        // playSound(correct.soundFile)
    }

    private func playSound(_ file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            print("⚠️ Missing audio file:", file)
            return
        }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()
            p.play()
            player = p
        } catch {
            print("Audio error:", error)
        }
    }
}
