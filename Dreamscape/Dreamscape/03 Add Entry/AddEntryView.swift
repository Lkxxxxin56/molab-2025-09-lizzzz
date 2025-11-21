//
//  AddEntryView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct AddEntryView: View {
    // @State private var dreamText: String = ""
    @StateObject private var draft = DreamDraft()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Describe your dream")
                .font(.title2)
                .bold()
            
            Text("Start by writing whatever you recall - who was there, where it happened, and what took place.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextEditor(text: $draft.text)
                .frame(minHeight: 200)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                )
                .scrollContentBackground(.hidden)
            
            // Character count (optional, but nice)
            Text("\(draft.text.count) characters")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // NavigationLink to next step (Factual Questions)
            NavigationLink {
                FactualQuestionsView(draft: draft)
            } label: {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .bold()
                    .background(draft.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            // disable when no text input
            .disabled(draft.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .navigationTitle("New Dream Entry")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AddEntryView()
    }
}
