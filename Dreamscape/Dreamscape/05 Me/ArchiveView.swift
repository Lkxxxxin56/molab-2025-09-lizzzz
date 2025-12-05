//
//  ArchivedDetailView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 12/4/25.
//

import SwiftUI

struct ArchivedDreamDetailView: View {
    let entry: DreamEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                visualizationSection
                Divider()
                summarySection
                Divider()
                infoSection
            }
            .padding()
        }
        .navigationTitle("Saved Dream")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Visualization (gradient + poem)
    
    private var visualizationSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            visualizationImage
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding([.top, .horizontal])

            
            VStack(alignment: .leading, spacing: 8) {
                Text("Dream Visual")
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
        .dreamCardStyle()
        .shadow(radius: 8, y: 4)
    }
    
    private var visualizationImage: Image {
        switch entry.atmosphere {
        case "Warm":
            return Image("warmDream")
        case "Dark":
            return Image("darkDream")
        case "Surreal":
            return Image("surrealDream")
        case "Floating":
            return Image("floatingDream")
        case "Confined":
            return Image("confinedDream")
        case "Airy":
            return Image("airyDream")
        case "Neon":
            return Image("neonDream")
        default: // "Foggy" or anything else
            return Image("foggyDream")
        }
    }

    
    private var visualizationGradient: LinearGradient {
        switch entry.atmosphere {
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
        let atmosphere = entry.atmosphere.lowercased()
        
        return [
            "In \(atmosphere) air, your story grew,",
            "threaded with \(emotion.lowercased()) in the night,",
            "it faded softly as you woke,",
            "a quiet echo of inner light."
        ]
    }
    
    private var primaryEmotionDuring: String? {
        entry.emotionsDuring.first
    }
    
    // MARK: - Summary (type + motif insight)
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Dream Type")
                    .font(.subheadline).bold()
                    .foregroundColor(.secondary)
                
                Text(dreamTypeInfo.type)
                    .font(.headline)
                
                Text(dreamTypeInfo.description)
                    .font(.subheadline).italic()
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Motif Insight")
                    .font(.subheadline).bold()
                    .foregroundColor(.secondary)
                
                ForEach(motifInsights, id: \.self) { line in
                    Text("• \(line)")
                        .font(.callout)
                }
            }
        }
    }
    
    private var dreamTypeInfo: DreamTypeInfo {
        if entry.isNightmare ||
            entry.emotionsDuring.contains("Terrified") ||
            entry.emotionsAfter.contains("Anxious") {
            
            return DreamTypeInfo(
                type: "Nightmare / Anxiety Dream",
                description:
                "A distressing dream involving fear, pressure, or emotional overload. These dreams often reflect unresolved tension or situations that feel out of control in waking life."
            )
        }
        
        if entry.emotionsDuring.contains("Nostalgic") {
            return DreamTypeInfo(
                type: "Nostalgia Dream",
                description:
                "A dream shaped by memory, longing, or emotional reflection. These dreams often revisit people or places tied to your personal history."
            )
        }
        
        if entry.atmosphere == "Surreal" || entry.atmosphere == "Neon" {
            return DreamTypeInfo(
                type: "Surreal Symbolic Dream",
                description:
                "A dream filled with symbolic or fantastical imagery. These dreams express deeper thoughts or emotions in a poetic, nonlinear way."
            )
        }
        
        if entry.emotionsDuring.contains("Excited") || entry.emotionsAfter.contains("Inspired") {
            return DreamTypeInfo(
                type: "Exploration Dream",
                description:
                "A dream centered on discovery, movement, or possibility. These dreams often reflect curiosity, creativity, or emerging personal growth."
            )
        }
        
        return DreamTypeInfo(
            type: "Reflective Dream",
            description:
            "A contemplative dream shaped by inner processing and emotional integration. These dreams reflect your current thoughts, moods, and transitions."
        )
    }
    
    private var motifInsights: [String] {
        var insights: [String] = []
        
        switch entry.atmosphere {
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
        
        if entry.emotionsDuring.contains("Confused") {
            insights.append("Feeling confused in dreams can reflect processing something unresolved or complex.")
        }
        if entry.emotionsDuring.contains("Excited") {
            insights.append("Excitement in dreams may point to new desires, curiosity, or emerging possibilities.")
        }
        if entry.emotionsDuring.contains("Lonely") {
            insights.append("Loneliness in dreams can highlight needs for connection or self-comfort.")
        }
        if entry.isNightmare {
            insights.append("Because this felt like a nightmare, your mind might be rehearsing threats in a safe space.")
        }
        
        if insights.isEmpty {
            insights.append("This dream’s symbols are open-ended—its meaning may change as you think about it.")
        }
        
        return insights
    }
    
    
    // MARK: - Factual info section
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.headline)
            
            Group {
                HStack {
                    Text("Dream date")
                    Spacer()
                    Text(entry.dreamDate, style: .date)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Nightmare")
                    Spacer()
                    Text(entry.isNightmare ? "Yes" : "No")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Woke you up")
                    Spacer()
                    Text(entry.wokeYouUp ? "Yes" : "No")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Clarity")
                    Spacer()
                    Text(clarityLabel)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .top) {
                    Text("Emotions (during)")
                    Spacer()
                    Text(entry.emotionsDuring.joined(separator: ", "))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
                HStack(alignment: .top) {
                    Text("Emotions (on waking)")
                    Spacer()
                    Text(entry.emotionsAfter.joined(separator: ", "))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            .font(.subheadline)
        }
    }
    
    private var clarityLabel: String {
        switch entry.clarity {
        case 0..<0.33:
            return "Blurry"
        case 0.33..<0.66:
            return "Medium"
        default:
            return "Vivid"
        }
    }
}

#Preview {
    NavigationStack {
        // Dummy entry for preview
        let entry = DreamEntry(
            id: UUID(),
            createdAt: Date(),
            text: "I was walking through a neon forest and the trees were made of glass.",
            dreamDate: Date(),
            isNightmare: false,
            wokeYouUp: false,
            clarity: 0.8,
            emotionsDuring: ["Curious", "Excited"],
            emotionsAfter: ["Inspired"],
            atmosphere: "Neon"
        )
        ArchivedDreamDetailView(entry: entry)
    }
}
