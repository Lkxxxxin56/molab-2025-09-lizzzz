//
//  DreamStore.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/17/25.
//

// DreamStore — central object that holds all saved dreams in memory

import SwiftUI
import Combine

class DreamStore: ObservableObject {
    @Published private(set) var entries: [DreamEntry] = []
    
    func add(_ entry: DreamEntry) {
        entries.insert(entry, at: 0)
    }
    
    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
}

