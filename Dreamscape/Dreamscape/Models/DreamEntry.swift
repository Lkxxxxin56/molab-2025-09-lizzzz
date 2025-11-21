//
//  DreamEntry.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/17/25.
//

// DreamEntry — a full, saved dream (goes in archive later)

import Foundation

struct DreamEntry: Identifiable {
    let id: UUID
    let createdAt: Date
    
    // Step 1 – Narrative
    var text: String
    
    // Step 2 – Factual
    var dreamDate: Date
    var isNightmare: Bool
    var wokeYouUp: Bool
    var clarity: Double   // 0...1
    
    // Step 3 – Emotional
    var emotionsDuring: [String]
    var emotionsAfter: [String]
    var atmosphere: String
}

