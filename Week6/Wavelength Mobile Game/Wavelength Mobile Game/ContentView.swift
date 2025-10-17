//
//  ContentView.swift
//  Wavelength Mobile Game
//
//  Created by Kexin Liu on 10/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var round = 1
    @State private var maxRounds = 6
    @State private var score = 0
    @State private var guessDeg: Double = 270
    @State private var currentPrompt: SpectrumPair? = nil
    
    // Spectrum prompt model
    struct SpectrumPair: Identifiable {
        let id = UUID()
        let left: String
        let right: String
    }

    // Prompt bank
    let spectrumPrompts: [SpectrumPair] = [
        SpectrumPair(left: "Hot", right: "Cold"),
        SpectrumPair(left: "Spicy", right: "Mild"),
        SpectrumPair(left: "Easy", right: "Hard"),
        SpectrumPair(left: "Weak", right: "Powerful"),
        SpectrumPair(left: "Cheap", right: "Expensive"),
        SpectrumPair(left: "Friendly", right: "Hostile"),
        SpectrumPair(left: "Natural", right: "Artificial"),
        SpectrumPair(left: "Simple", right: "Complex"),
        SpectrumPair(left: "Light", right: "Dark"),
        SpectrumPair(left: "Safe", right: "Risky"),
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Wavelength Mobile Game")
                .font(.title3).bold()

            HStack {
                Text("Round \(round)/\(maxRounds)")
                Spacer()
                Text("Score: \(score)")
            }
            .font(.headline)
            
            if let prompt = currentPrompt {
                        Text("\(prompt.left)  ⟷  \(prompt.right)")
                    }
                    Button("New Prompt") {
                        currentPrompt = spectrumPrompts.randomElement()!
                    }
                    .buttonStyle(.bordered)

            Dial(guessDeg: $guessDeg)
                .frame(height: 360)
                .padding(.horizontal, 16)

            Text(String(format: "Angle: %.1f°", guessDeg))
                .font(.title3)
                .monospacedDigit()

            Spacer()
        }
        .onAppear {
            currentPrompt = spectrumPrompts.randomElement()!
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
