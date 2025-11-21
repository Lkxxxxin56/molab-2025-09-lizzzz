//
//  SummaryView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/20/25.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var draft: DreamDraft
    @EnvironmentObject var dreamStore: DreamStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 1) Visualization section
                visualizationSection
                Divider()
                // 2) Dream summary section
                summarySection
                Divider()
                // 3) Actions / buttons section
                actionsSection
            }
            .padding()
        }
        .navigationTitle("Dream Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - 1) Visualization (image placeholder + poem)
    
    private var visualizationSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            
            // Top: image placeholder
            visualizationGradient
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding([.top, .horizontal])

            // Bottom: text on white card
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Dreamscape")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(poemLines, id: \.self) { line in
                        Text(line)
                    }
                }
                .font(.callout.italic())
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground)) // white in light mode, card-like in dark mode
        )
        .shadow(radius: 8, y: 4)
    }

    
    private var visualizationGradient: LinearGradient {
        switch draft.atmosphere {
        case "Warm":
            return LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Dark":
            return LinearGradient(colors: [.purple, .black], startPoint: .top, endPoint: .bottom)
        case "Surreal":
            return LinearGradient(colors: [.purple, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Floating":
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Confined":
            return LinearGradient(colors: [.gray, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Airy":
            return LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
        case "Neon":
            return LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        default: // "Foggy" or anything else
            return LinearGradient(colors: [.gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private var poemLines: [String] {
        let emotion = primaryEmotionDuring ?? "a feeling you can’t name"
        let atmosphere = draft.atmosphere.lowercased()
        
        return [
            "In \(atmosphere) air, your story grew,",
            "threaded with \(emotion.lowercased()) in the night,",
            "it faded softly as you woke,",
            "a quiet echo of inner light."
        ]
    }
    
    private var primaryEmotionDuring: String? {
        draft.emotionsDuring.first
    }
    
    // MARK: - 2) Dream summary (type + motifs)
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dream Summary")
                .font(.title3)
                .bold()
            
            // Dream type
            VStack(alignment: .leading, spacing: 4) {
                Text("Dream Type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(dreamType)
                    .font(.headline)
            }
            
            // Motif explanation
            VStack(alignment: .leading, spacing: 4) {
                Text("Motif Insight")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach(motifInsights, id: \.self) { line in
                    Text("• \(line)")
                        .font(.callout)
                }
            }
        }
    }
    
    private var dreamType: String {
        if draft.isNightmare || draft.emotionsDuring.contains("Terrified") || draft.emotionsAfter.contains("Anxious") {
            return "Anxiety / Nightmare Dream"
        } else if draft.emotionsDuring.contains("Nostalgic") {
            return "Nostalgia / Memory Dream"
        } else if draft.atmosphere == "Surreal" || draft.atmosphere == "Neon" {
            return "Surreal Symbolic Dream"
        } else if draft.emotionsDuring.contains("Excited") {
            return "Exploration / Adventure Dream"
        } else {
            return "Reflective Dream"
        }
    }
    
    private var motifInsights: [String] {
        var insights: [String] = []
        
        // Atmosphere-based
        switch draft.atmosphere {
        case "Foggy":
            insights.append("Foggy dreams can feel like half-remembered thoughts or transitions.")
        case "Warm":
            insights.append("Warm atmospheres often reflect safety, intimacy, or emotional closeness.")
        case "Dark":
            insights.append("Dark dream spaces sometimes hold fears, secrets, or things not yet understood.")
        case "Surreal":
            insights.append("Surreal settings often show up when your mind is remixing reality in symbolic ways.")
        case "Floating":
            insights.append("Floating feelings may connect to freedom, escape, or drifting between states.")
        case "Confined":
            insights.append("Confined spaces can mirror pressure, expectations, or feeling stuck.")
        case "Airy":
            insights.append("Airy spaces tend to feel light, open, and imaginative.")
        case "Neon":
            insights.append("Neon atmospheres often echo overstimulation, intensity, or hyperreal experiences.")
        default:
            break
        }
        
        // Emotional-based
        if draft.emotionsDuring.contains("Confused") {
            insights.append("Feeling confused in dreams can reflect processing something unresolved or complex.")
        }
        if draft.emotionsDuring.contains("Excited") {
            insights.append("Excitement in dreams may point to new desires, curiosity, or emerging possibilities.")
        }
        if draft.emotionsDuring.contains("Lonely") {
            insights.append("Loneliness in dreams can highlight needs for connection or self-comfort.")
        }
        if draft.isNightmare {
            insights.append("Because this felt like a nightmare, your mind might be rehearsing threats in a safe space.")
        }
        
        if insights.isEmpty {
            insights.append("This dream’s symbols are open-ended—its meaning may change as you think about it.")
        }
        
        return insights
    }
    
    // MARK: - 3) Actions / buttons
    
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Primary action
            Button {
                let entry = draft.toEntry()     // Convert draft → final DreamEntry
                dreamStore.add(entry)           // Save it
                dismiss()                       // Pop back to previous screen
            } label: {
                Text("Save to Dream Diary")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .bold()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            Button(role: .destructive) {
                // later: discard / pop to root
                print("Discard tapped")
            } label: {
                Text("Discard this entry")
                    .frame(maxWidth: .infinity)
            }
            
            Divider().padding(.vertical, 4)
            
            // Secondary actions row
            HStack(spacing: 16) {
                Button {
                    print("Share tapped")
                } label: {
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button {
                    print("Save image tapped")
                } label: {
                    VStack {
                        Image(systemName: "photo")
                        Text("Save Image")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button {
                    print("Chat AI tapped")
                } label: {
                    VStack {
                        Image(systemName: "sparkles")
                        Text("Ask Dream AI")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    NavigationStack {
        SummaryView(draft: DreamDraft())
            .environmentObject(DreamStore())
    }
}
