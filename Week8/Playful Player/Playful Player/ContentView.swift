//
//  ContentView.swift
//  Playful Player
//
//  Created by Kexin Liu on 10/30/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    // Player loading a bundled video
    @State private var player: AVPlayer? = {
        // Try to load a pre-bundled video named "sample.mp4"
        if let url = Bundle.main.url(forResource: "timelapse1030", withExtension: "mp4") {
            return AVPlayer(url: url)
        }
        return nil
    }()
    
    @State private var isPlaying = false
    @State private var speed: Double = 1.0
    @State private var isReversing = false
    
    // Mirror modes for UI
    enum MirrorMode: String, CaseIterable, Identifiable {
        case none = "None"
        case horizontal = "left/right"
        case vertical = "top/bottom"
        var id: String {rawValue}
    }
    @State private var mirrorMode: MirrorMode = .none
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // Title + Icon
                VStack(spacing: 8) {
                    Image(systemName: "film.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    
                    Text("Playful Player")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    
                    Text("Mirror • Reverse • Speed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)
                
                // Video area
                Group {
                    if let player {
                        VideoPlayer(player: player)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                // Optional subtle border
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(.quaternary, lineWidth: 1)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 350)
                            .onAppear {
                                // Start paused at the beginning
                                player.seek(to: .zero)
                            }
                    } else {
                        // Fallback UI if the video wasn't found
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                            Text("Missing bundled video")
                                .font(.headline)
                            Text("Add sample.mp4 to the app target.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Basic transport: Play/Pause/Restart buttons
                HStack(spacing: 16) {
                    Button {
                        guard let player else { return }
                        if isPlaying {
                            player.pause()
                            isPlaying = false
                        } else {
                            // When starting playback, apply the chosen speed
                            player.play()
                            player.rate = Float(speed)
                            isPlaying = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            Text(isPlaying ? "Pause" : "Play")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        guard let player else { return }
                        player.pause()
                        player.seek(to: .zero)
                        isPlaying = false
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "backward.end.fill")
                            Text("Restart")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                // Speed slider UI
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Speed")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2fx", speed))
                            .font(.subheadline)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $speed, in: 0.25...2.0, step: 0.08) {
                        Text("Playback Speed")
                    } minimumValueLabel: {
                        Text("0.25x").font(.caption)
                    } maximumValueLabel: {
                        Text("2.0x").font(.caption)
                    }
                    .onChange(of: speed) {_ in
                        applySpeed()
                    }
                    
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Feature 2: Reverse
                    Text("Reverse")
                        .font(.headline)
                    Button {
                        isReversing.toggle()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isReversing ? "arrow.uturn.left.circle.fill" : "arrow.uturn.left.circle")
                            Text(isReversing ? "Reverse: ON" : "Reverse: OFF")
                        }
                        //.padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                    }
                    .tint(isReversing ? .blue : .gray.opacity(0.6))
                    
                    // Feature 3: Mirror
                    // Mirror segmented control
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Mirror")
                            .font(.headline)

                        Picker("Mirror", selection: $mirrorMode) {
                            Text("None").tag(MirrorMode.none)
                            Text("Left/Right").tag(MirrorMode.horizontal)
                            Text("Top/Bottom").tag(MirrorMode.vertical)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .onDisappear {
                    player?.pause() // “If player exists (not nil), call .pause(); if it’s nil, skip this line safely.”
                }
            }
        }
        private func applySpeed() {
            guard let player else {return}
            if isPlaying {
                player.rate = Float(speed)
        }
    }
}

#Preview {
    ContentView()
}
