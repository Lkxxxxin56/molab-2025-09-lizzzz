//
//  DreamscapeApp.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

@main
struct DreamscapeApp: App {
    @StateObject private var dreamStore = DreamStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dreamStore)
        }
    }
}
