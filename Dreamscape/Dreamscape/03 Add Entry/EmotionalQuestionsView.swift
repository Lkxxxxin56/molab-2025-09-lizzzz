//
//  EmotionalQuestionsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/14/25.
//

import SwiftUI

struct EmotionalQuestionsView: View {
//    @State private var emotionsDuring: Set<String> = [] // use set instead of an array bc it has no duplicate elements and is faster for access
//    @State private var emotionsAfter: Set<String> = []
//    @State private var selectedAtmosphere: String = ""
    @ObservedObject var draft = DreamDraft()
    
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
    
    var body: some View {
        Text("Emotional Questions View")
        Form {
            // Q1: Emotions during the dream
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
            
            // Q2: Emotions after the dream
            Section(header: Text("Emotions after the dream")) {
                ForEach(afterOptions, id: \.self) {
                    emotion in
                    MultipleSelectionRow(
                        title: emotion,
                        isSelected: draft.emotionsAfter.contains(emotion)
                    ) {
                        toggleSelection(emotion, in: &draft.emotionsAfter)
                    }
                }
            }
            
            // Q3: Dream atmosphere
            Section(header: Text("Dream atmosphere")) {
                Picker("Atmosphere", selection: $draft.atmosphere) {
                    ForEach(atmosphereOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }

            
            Section {
                NavigationLink {
                    SummaryView(draft: draft)
                } label: {
                    Text("Get Your Summary")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Step3: Feelings")
        .navigationBarTitleDisplayMode(.inline)
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

private func toggleSelection(_ item: String, in set: inout Set<String>) {
    if set.contains(item) {
        set.remove(item)
    } else {
        set.insert(item)
    }
}



#Preview {
    EmotionalQuestionsView(draft: DreamDraft())
}
