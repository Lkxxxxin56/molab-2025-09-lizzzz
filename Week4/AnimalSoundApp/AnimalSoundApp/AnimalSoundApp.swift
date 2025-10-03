//
//  AnimalSoundAppApp.swift
//  AnimalSoundApp
//
//  Created by Kexin Liu on 10/2/25.
//

import SwiftUI

@main
struct AnimalSoundApp: App {
    // share one audio manager app-wide
    @State var audio = AudioManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audio)
        }
    }
}
