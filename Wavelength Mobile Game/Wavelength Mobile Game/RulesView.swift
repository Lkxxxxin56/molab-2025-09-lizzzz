//
//  RulesView.swift
//  Wavelength Mobile Game
//
//  Created by Kexin Liu on 10/31/25.
//

import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("How to Play")
                        .font(.title2).bold()
                        .padding(.bottom, 4)

                    Group {
                        rule("Setup (together):", "Pick players/teams. Get the dial ready.")
                        rule("Randomize Target (Player 1):", "Secretly set a hidden spot on the semicircle.")
                        rule("Reveal Prompt (together):", "Draw a spectrum (e.g., Hot ↔ Cold).")
                        rule("Give One Clue (Player 1):", "Say a word/phrase that hints at the hidden spot.")
                        rule("Discuss & Guess (Player 2):", "Rotate the pointer to where you think it is.")
                        rule("Reveal (together):", "Show the hidden band and compare to the guess.")
                        rule("Score (together):", "Closer = more points (4 / 3 / 2 / 0).")
                        rule("Next Round:", "Swap roles and draw a new prompt.")
                    }
                    .font(.body)

                    Divider().padding(.vertical, 8)

                    Text("Tips")
                        .font(.title3).bold()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Keep clues short and evocative.")
                        Text("• Avoid giving away exact position words.")
                        Text("• Use shared context with your partner!")
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationTitle("Rules")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func rule(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).bold()
            Text(detail).foregroundStyle(.secondary)
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
