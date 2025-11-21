//
//  DreamDraft.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/17/25.
//

// DreamDraft — temporary data while the user is filling the 3 steps

import SwiftUI
import Combine

class DreamDraft: ObservableObject {
    
    // Step 1 – Narrative
    @Published var text: String = ""
    
    // Step 2 – Factual
    @Published var dreamDate: Date = Date()
    @Published var isNightmare: Bool = false
    @Published var wokeYouUp: Bool = false
    @Published var clarity: Double = 0.5  // 0...1
    
    // Step 3 – Emotional
    @Published var emotionsDuring: Set<String> = []
    @Published var emotionsAfter: Set<String> = []
    @Published var atmosphere: String = "Foggy"
    
    // Turn this draft into a final DreamEntry
    func toEntry() -> DreamEntry {
        DreamEntry(
            id: UUID(),
            createdAt: Date(),
            text: text,
            dreamDate: dreamDate,
            isNightmare: isNightmare,
            wokeYouUp: wokeYouUp,
            clarity: clarity,
            emotionsDuring: Array(emotionsDuring),
            emotionsAfter: Array(emotionsAfter),
            atmosphere: atmosphere
        )
    }
}


