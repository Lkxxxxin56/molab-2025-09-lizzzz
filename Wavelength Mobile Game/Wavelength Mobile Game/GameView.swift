//
//  GamePage.swift
//  Wavelength Mobile Game
//
//  Created by Kexin Liu on 10/24/25.
//

import SwiftUI

// MARK: - Model
struct SpectrumPair: Identifiable {
    let id = UUID()
    let left: String
    let right: String
}

// Prompt bank (can stay global like this)
let spectrumPrompts: [SpectrumPair] = [
    .init(left: "Introvert", right: "Extrovert"),
    .init(left: "Villain", right: "Hero"),
    .init(left: "Useless", right: "Essential"),
    .init(left: "Clean", right: "Dirty"),
    .init(left: "Safe", right: "Risky"),
    .init(left: "Overrated", right: "Underrated"),
    .init(left: "Honest", right: "Fake"),
    .init(left: "Sweet", right: "Salty"),
    .init(left: "Chill", right: "Intense"),
    .init(left: "Quiet", right: "Loud"),
    .init(left: "Easy", right: "Difficult"),
    .init(left: "Normal", right: "Weird"),
    .init(left: "Practical", right: "Impractical"),
    .init(left: "Healthy", right: "Unhealthy"),
    .init(left: "Realistic", right: "Dreamy"),
    .init(left: "Genius", right: "Stupid"),
    .init(left: "Main Character", right: "Background Character"),
    .init(left: "Day Activity", right: "Night Activity"),
    .init(left: "Teenagers", right: "Adults"),
    .init(left: "Popular", right: "Niche"),
    .init(left: "Predictable", right: "Unpredictable"),
    .init(left: "Spicy", right: "Mild"),
    .init(left: "Fancy", right: "Basic"),
    .init(left: "Boring", right: "Exciting"),
    .init(left: "Harmless", right: "Dangerous"),
    .init(left: "Simple", right: "Complicated"),
    .init(left: "Lazy", right: "Motivated"),
    .init(left: "Nice", right: "Mean")
]

// MARK: - Game View

struct GameView: View {
    @State private var round: Int = 1
    @State private var maxRounds: Int = 6
    @State private var score: Int = 0
    @State private var guessDeg: Double = 270
    @State private var currentPrompt: SpectrumPair =
        spectrumPrompts.randomElement()!
    @State private var showRules = false

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Wavelength Game")
                    .font(.title).bold()
                // (Optional) rules button specific to game page
                Button("Rules") {
                    showRules = true
                }
                .buttonStyle(.bordered)
            }

            // Round + Score
            HStack {
                Text("Round \(round)/\(maxRounds)")
                Spacer()
                Text("Score: \(score)")
            }
            .font(.headline)

            // Prompt
            Text("\(currentPrompt.left)  ⟷  \(currentPrompt.right)")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("New Prompt") {
                if let newPrompt = spectrumPrompts.randomElement() {
                    currentPrompt = newPrompt
                }
            }
            .buttonStyle(.borderedProminent)

            Dial(guessDeg: $guessDeg)
                .frame(height: 360)
                .padding(.horizontal, 16)

            Text(String(format: "Angle: %.1f°", guessDeg))
                .font(.title3)
                .monospacedDigit()

            Spacer()
        }
        .sheet(isPresented: $showRules) {
            RulesView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .padding()
        // .navigationTitle("Game")
        .onAppear {
            // ensure a prompt is present in the 1st round
            if spectrumPrompts.isEmpty == false {
                currentPrompt = spectrumPrompts.randomElement()!
            }
        }
    }
}

// MARK: - Preview

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameView()
        }
    }
}
