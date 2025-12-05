//
//  EmotionalQuestionsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/14/25.
//

import SwiftUI

struct EmotionalQuestionsView: View {
    @ObservedObject var draft: DreamDraft
    
    private let duringOptions = [
        "Confused", "Terrified", "Excited", "Nostalgic",
        "Curious", "Lonely", "Relieved", "Overwhelmed"
    ]
    
    private let afterOptions = [
        "Relieved", "Shaken", "Inspired", "Tired",
        "Neutral", "Anxious", "Calm", "Still processing"
    ]
    
    private let atmosphereOptions = [
        "Foggy", "Warm", "Dark", "Surreal",
        "Floating", "Confined", "Airy", "Neon"
    ]
    
    // ✅ Validation: must pick at least one emotion in each category
    private var canFinish: Bool {
        !draft.emotionsDuring.isEmpty &&
        !draft.emotionsAfter.isEmpty &&
        !draft.atmosphere.isEmpty
    }
    
    var body: some View {
        Form {
            // Emotions during the dream
            Section(header: Text("Emotions during the dream")) {
                ForEach(duringOptions, id: \.self) { emotion in
                    MultipleSelectionRow(
                        title: emotion,
                        isSelected: draft.emotionsDuring.contains(emotion)
                    ) {
                        toggleSelection(emotion, in: &draft.emotionsDuring)
                    }
                }
            }
            
            // Emotions upon waking
            Section(header: Text("Emotions upon waking")) {
                ForEach(afterOptions, id: \.self) { emotion in
                    MultipleSelectionRow(
                        title: emotion,
                        isSelected: draft.emotionsAfter.contains(emotion)
                    ) {
                        toggleSelection(emotion, in: &draft.emotionsAfter)
                    }
                }
            }
            
            // Dream atmosphere
            Section(header: Text("Dream atmosphere")) {
                Picker("Atmosphere", selection: $draft.atmosphere) {
                    ForEach(atmosphereOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }
            
            // Debug (optional): see how many you selected
            /*
            Section {
                Text("Selected during: \(draft.emotionsDuring.count)")
                Text("Selected after: \(draft.emotionsAfter.count)")
            }
            */
            
            // Finish button + error message
            Section {
                if !canFinish {
                    Text("Please select at least one emotion during the dream and one emotion upon waking.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                NavigationLink {
                    SummaryView(draft: draft)
                } label: {
                    Text("Finish Entry")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(!canFinish)
            }
        }
        .navigationTitle("Step 3: Feelings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper to toggle items in a Set
    private func toggleSelection(_ item: String, in set: inout Set<String>) {
        if set.contains(item) {
            set.remove(item)
        } else {
            set.insert(item)
        }
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


#Preview {
    EmotionalQuestionsView(draft: DreamDraft())
}
