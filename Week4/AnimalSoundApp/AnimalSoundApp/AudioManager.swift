//
//  Untitled.swift
//  AnimalSoundApp
//
//  Created by Kexin Liu on 10/2/25.
//

import Foundation
import AVFoundation
import Observation

@Observable
class AudioManager {
    private var player: AVAudioPlayer?
    private(set) var isPlaying = false
    private(set) var currentName: String? = nil

    func play(name: String, file: String, loop: Bool = false) {
        stop() // stop anything currently playing

        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            print("⚠️ Missing audio file:", file)
            return
        }

        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = loop ? -1 : 0
            p.prepareToPlay()
            p.play()
            player = p
            currentName = name
            isPlaying = true
        } catch {
            print("Audio error:", error)
        }
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
        currentName = nil
    }
}
