//
//  DiaryView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/20/25.
//

import SwiftUI

struct DiaryArchiveView: View {
    @EnvironmentObject var dreamStore: DreamStore
    
    var body: some View {
        NavigationStack {
            Group {
                if dreamStore.entries.isEmpty {
                    VStack(spacing: 12) {
                        Text("No dreams saved yet")
                            .font(.title3)
                            .bold()
                        Text("Once you save entries from the summary screen, they’ll appear here with their visuals, poems, and details.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(dreamStore.entries) { entry in
                                NavigationLink {
                                    ArchivedDreamDetailView(entry: entry)
                                } label: {
                                    archiveCard(for: entry)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Dream Diary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func archiveCard(for entry: DreamEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date + type line
            HStack(spacing: 6) {
                Text(entry.dreamDate, style: .date)
                Text("•")
                Text(dreamTypeLabel(for: entry))
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            // Snippet
            Text(entry.text)
                .font(.subheadline)
                .lineLimit(3)
            
            // Chips
            HStack(spacing: 8) {
                Text(entry.atmosphere)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.08))
                    )
                    .foregroundColor(.blue)
                
                if entry.isNightmare {
                    Text("Nightmare")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.1))
                        )
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    // Reuse a light-weight version of your dream type logic
    private func dreamTypeLabel(for entry: DreamEntry) -> String {
        if entry.isNightmare ||
            entry.emotionsDuring.contains("Terrified") ||
            entry.emotionsAfter.contains("Anxious") {
            return "Nightmare / Anxiety"
        } else if entry.emotionsDuring.contains("Nostalgic") {
            return "Nostalgia"
        } else if entry.atmosphere == "Surreal" || entry.atmosphere == "Neon" {
            return "Surreal"
        } else if entry.emotionsDuring.contains("Excited") || entry.emotionsAfter.contains("Inspired") {
            return "Exploration"
        } else {
            return "Reflective"
        }
    }
}

#Preview {
    NavigationStack {
        DiaryArchiveView()
            .environmentObject(DreamStore())
    }
}

