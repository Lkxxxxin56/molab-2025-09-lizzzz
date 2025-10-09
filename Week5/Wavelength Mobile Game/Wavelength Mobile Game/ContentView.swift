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

            Dial(guessDeg: $guessDeg)
                .frame(height: 360)
                .padding(.horizontal, 16)

            Text(String(format: "Angle: %.1f°", guessDeg))
                .font(.title3)
                .monospacedDigit()

            Spacer()
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
