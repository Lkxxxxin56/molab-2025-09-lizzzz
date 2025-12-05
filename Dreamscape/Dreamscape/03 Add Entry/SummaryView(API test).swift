////
////  SummaryView.swift
////  Dreamscape
////
////  Created by Kexin Liu on 11/20/25.
////
//
//import SwiftUI
//
//struct DreamAIResponse: Decodable {
//    let imageURL: String?
//    let poem: [String]
//}
//
//struct DreamTypeInfo {
//    let type: String
//    let description: String
//}
//
//struct SummaryView: View {
//    @ObservedObject var draft: DreamDraft
//    @EnvironmentObject var dreamStore: DreamStore
//    @Environment(\.dismiss) var dismiss
//    @State private var isLoadingAI = false
//    @State private var aiErrorMessage: String?
//    @State private var aiPoemLines: [String] = []
//    @State private var aiImageURL: URL?
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 24) {
//                // 1) Visualization section
//                visualizationSection
//                Divider()
//                // 2) Dream summary section
//                summarySection
//                Divider()
//                // 3) Actions / buttons section
//                actionsSection
//            }
//            .padding()
//        }
//        .navigationTitle("Dream Summary")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            Task {
//                await fetchDreamAI()
//            }
//        }
//    }
//    
//    // MARK: - 1) Visualization (image placeholder + poem)
//    
//    private var visualizationSection: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            // Top: image (API image or gradient fallback)
//            ZStack {
//                if let url = aiImageURL {
//                    AsyncImage(url: url) { phase in
//                        switch phase {
//                        case .empty:
//                            ZStack {
//                                visualizationGradient
//                                ProgressView()
//                                    .tint(.white)
//                            }
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                        case .failure:
//                            visualizationGradient
//                        @unknown default:
//                            visualizationGradient
//                        }
//                    }
//                } else {
//                    ZStack {
//                        visualizationGradient
//                        if isLoadingAI {
//                            ProgressView("Generating your dream visual…")
//                                .font(.caption)
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            }
//            .frame(height: 220)
//            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
//            .padding([.top, .horizontal])
//            
//            // Bottom: text on white card
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Your Dreamscape")
//                    .font(.headline)
//                
//                if let error = aiErrorMessage {
//                    Text(error)
//                        .font(.caption)
//                        .foregroundColor(.red)
//                }
//                
//                let linesToShow = aiPoemLines.isEmpty ? poemLines : aiPoemLines
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    ForEach(linesToShow, id: \.self) { line in
//                        Text(line)
//                    }
//                }
//                .font(.callout.italic())
//                .foregroundColor(.secondary)
//            }
//            .padding(.horizontal)
//            .padding(.top, 12)
//            .padding(.bottom, 16)
//        }
//        .background(
//            RoundedRectangle(cornerRadius: 24, style: .continuous)
//                .fill(Color(.systemBackground))
//        )
//        .shadow(radius: 8, y: 4)
//    }
//
//
//    
//    private var visualizationGradient: LinearGradient {
//        switch draft.atmosphere {
//        case "Warm":
//            return LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
//        case "Dark":
//            return LinearGradient(colors: [.purple, .black], startPoint: .top, endPoint: .bottom)
//        case "Surreal":
//            return LinearGradient(colors: [.purple, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
//        case "Floating":
//            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
//        case "Confined":
//            return LinearGradient(colors: [.gray, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
//        case "Airy":
//            return LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
//        case "Neon":
//            return LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
//        default: // "Foggy" or anything else
//            return LinearGradient(colors: [.gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
//        }
//    }
//    
//    private var poemLines: [String] {
//        let emotion = primaryEmotionDuring ?? "a feeling you can’t name"
//        let atmosphere = draft.atmosphere.lowercased()
//        
//        return [
//            "In \(atmosphere) air, your story grew,",
//            "threaded with \(emotion.lowercased()) in the night,",
//            "it faded softly as you woke,",
//            "a quiet echo of inner light."
//        ]
//    }
//    
//    private var primaryEmotionDuring: String? {
//        draft.emotionsDuring.first
//    }
//    
//    // MARK: - 2) Dream summary (type + motifs)
//    
//    private var summarySection: some View {
//        VStack(alignment: .leading, spacing: 12) {
////            Text("Dream Summary")
////                .font(.title3)
////                .bold()
//            
//            // Dream type
//            VStack(alignment: .leading, spacing: 6) {
//                Text("Dream Type")
//                    .font(.subheadline).bold()
//                    .foregroundColor(.secondary)
//                
//                Text(dreamTypeInfo.type)
//                    .font(.headline)
//
//                Text(dreamTypeInfo.description)
//                    .font(.subheadline).italic()
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//            // Motif explanation
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Motif Insight")
//                    .font(.subheadline).bold()
//                    .foregroundColor(.secondary)
//                
//                ForEach(motifInsights, id: \.self) { line in
//                    Text("• \(line)")
//                        .font(.callout)
//                }
//            }
//        }
//    }
//    
//    private var dreamTypeInfo: DreamTypeInfo {
//        // 1. Anxiety / Nightmare Dream
//        if draft.isNightmare ||
//            draft.emotionsDuring.contains("Terrified") ||
//            draft.emotionsAfter.contains("Anxious") {
//
//            return DreamTypeInfo(
//                type: "Nightmare / Anxiety Dream",
//                description:
//                "A distressing dream involving fear, pressure, or emotional overload. These dreams often reflect unresolved tension or situations that feel out of control in waking life."
//            )
//        }
//
//        // 2. Nostalgia / Memory Dream
//        if draft.emotionsDuring.contains("Nostalgic") {
//            return DreamTypeInfo(
//                type: "Nostalgia Dream",
//                description:
//                "A dream shaped by memory, longing, or emotional reflection. These dreams often revisit people or places tied to your personal history."
//            )
//        }
//
//        // 3. Symbolic Surreal Dream
//        if draft.atmosphere == "Surreal" || draft.atmosphere == "Neon" {
//            return DreamTypeInfo(
//                type: "Surreal Symbolic Dream",
//                description:
//                "A dream filled with symbolic or fantastical imagery. These dreams express deeper thoughts or emotions in a poetic, nonlinear way."
//            )
//        }
//
//        // 4. Adventure / Exploration Dream
//        if draft.emotionsDuring.contains("Excited") || draft.emotionsAfter.contains("Inspired") {
//            return DreamTypeInfo(
//                type: "Exploration Dream",
//                description:
//                "A dream centered on discovery, movement, or possibility. These dreams often reflect curiosity, creativity, or emerging personal growth."
//            )
//        }
//
//        // 5. Default Reflective Dream
//        return DreamTypeInfo(
//            type: "Reflective Dream",
//            description:
//            "A contemplative dream shaped by inner processing and emotional integration. These dreams reflect your current thoughts, moods, and transitions."
//        )
//    }
//
//    
//    private var motifInsights: [String] {
//        var insights: [String] = []
//        
//        // Atmosphere-based
//        switch draft.atmosphere {
//        case "Foggy":
//            insights.append("Foggy dreams can feel like half-remembered thoughts or transitions.")
//        case "Warm":
//            insights.append("Warm atmospheres often reflect safety, intimacy, or emotional closeness.")
//        case "Dark":
//            insights.append("Dark dream spaces sometimes hold fears, secrets, or things not yet understood.")
//        case "Surreal":
//            insights.append("Surreal settings often show up when your mind is remixing reality in symbolic ways.")
//        case "Floating":
//            insights.append("Floating feelings may connect to freedom, escape, or drifting between states.")
//        case "Confined":
//            insights.append("Confined spaces can mirror pressure, expectations, or feeling stuck.")
//        case "Airy":
//            insights.append("Airy spaces tend to feel light, open, and imaginative.")
//        case "Neon":
//            insights.append("Neon atmospheres often echo overstimulation, intensity, or hyperreal experiences.")
//        default:
//            break
//        }
//        
//        // Emotional-based
//        if draft.emotionsDuring.contains("Confused") {
//            insights.append("Feeling confused in dreams can reflect processing something unresolved or complex.")
//        }
//        if draft.emotionsDuring.contains("Excited") {
//            insights.append("Excitement in dreams may point to new desires, curiosity, or emerging possibilities.")
//        }
//        if draft.emotionsDuring.contains("Lonely") {
//            insights.append("Loneliness in dreams can highlight needs for connection or self-comfort.")
//        }
//        if draft.isNightmare {
//            insights.append("Because this felt like a nightmare, your mind might be rehearsing threats in a safe space.")
//        }
//        
//        if insights.isEmpty {
//            insights.append("This dream’s symbols are open-ended—its meaning may change as you think about it.")
//        }
//        
//        return insights
//    }
//    // MARK: - 3) API calling
//    private func fetchDreamAI() async {
//        // Avoid refetching if we already have data
//        if !aiPoemLines.isEmpty || aiImageURL != nil { return }
//        
//        isLoadingAI = true
//        aiErrorMessage = nil
//        
//        // 1. Build URL
//        guard let url = URL(string: "https://your-backend.com/api/dream") else {
//            aiErrorMessage = "Invalid API URL."
//            isLoadingAI = false
//            return
//        }
//        
//        // 2. Build request body from draft
//        let requestBody: [String: Any] = [
//            "description": draft.text,
//            "emotionsDuring": Array(draft.emotionsDuring),
//            "emotionsAfter": Array(draft.emotionsAfter),
//            "atmosphere": draft.atmosphere,
//            "isNightmare": draft.isNightmare
//        ]
//        
//        do {
//            let data = try JSONSerialization.data(withJSONObject: requestBody, options: [])
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            // ⚠️ Do NOT put your OpenAI key here.
//            // If your backend needs an auth token, use a backend-only secret,
//            // or a short-lived token issued by your server.
//            request.httpBody = data
//            
//            // 3. Perform request
//            let (responseData, response) = try await URLSession.shared.data(for: request)
//            
//            if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
//                aiErrorMessage = "Server error: \(http.statusCode)"
//                isLoadingAI = false
//                return
//            }
//            
//            // 4. Decode response
//            let decoded = try JSONDecoder().decode(DreamAIResponse.self, from: responseData)
//            
//            // 5. Update UI on main thread
//            await MainActor.run {
//                self.aiPoemLines = decoded.poem
//                if let urlString = decoded.imageURL, let url = URL(string: urlString) {
//                    self.aiImageURL = url
//                }
//                self.isLoadingAI = false
//            }
//            
//        } catch {
//            await MainActor.run {
//                self.aiErrorMessage = "Could not generate dream art right now."
//                self.isLoadingAI = false
//            }
//            print("Dream AI error:", error)
//        }
//    }
//
//    // MARK: - 4) Actions / buttons
//    
//    private var actionsSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Primary action
//            Button {
//                let entry = draft.toEntry()     // Convert draft → final DreamEntry
//                dreamStore.add(entry)           // Save it
//                dismiss()                       // Pop back to previous screen
//            } label: {
//                Text("Save to Dream Diary")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .bold()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            
//            Button(role: .destructive) {
//                // later: discard / pop to root
//                print("Discard tapped")
//            } label: {
//                Text("Discard this entry")
//                    .frame(maxWidth: .infinity)
//            }
//            
//            Divider().padding(.vertical, 4)
//            
//            // Secondary actions row
//            HStack(spacing: 16) {
//                Button {
//                    print("Share tapped")
//                } label: {
//                    VStack {
//                        Image(systemName: "square.and.arrow.up")
//                        Text("Share")
//                            .font(.caption)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                
//                Button {
//                    print("Save image tapped")
//                } label: {
//                    VStack {
//                        Image(systemName: "photo")
//                        Text("Save Image")
//                            .font(.caption)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                
//                Button {
//                    print("Chat AI tapped")
//                } label: {
//                    VStack {
//                        Image(systemName: "sparkles")
//                        Text("Ask Dream AI")
//                            .font(.caption)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            .foregroundColor(.blue)
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        SummaryView(draft: DreamDraft())
//            .environmentObject(DreamStore())
//    }
//}
