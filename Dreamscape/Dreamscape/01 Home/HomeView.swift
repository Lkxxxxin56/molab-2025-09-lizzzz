//
//  HomeView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dreamStore: DreamStore
    private let funFacts = DreamFact.sampleFacts
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Top greeting
                    headerSection
                    
                    // Big CTA: add new dream
                    newEntryCard
                    
                    // Fun facts horizontal scroller
                    funFactsSection
                    
                    // Streak + total dreams
                    statsSection
                    
                    // Recent dreams
                    recentDreamsSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome back, Dreamer")
                .font(.title2)
                .bold()
            Text("Capture last night before it fades.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - New Entry Card
    
    private var newEntryCard: some View {
        NavigationLink {
            AddEntryView()
        } label: {
            HStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.purple, .blue],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Log a new dream")
                        .font(.headline)
                    Text("Write a quick snapshot while the details are still fresh.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .dreamCardStyle()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Fun Facts
    
    private var funFactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fun facts about dreams")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(funFacts) { fact in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(fact.title)
                                .font(.subheadline)
                                .bold()
                            Text(fact.text)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .frame(width: 260, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Stats / Streak
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your dream stats")
                .font(.headline)
            
            if dreamStore.entries.isEmpty {
                Text("You haven’t logged any dreams yet. Your streak and patterns will appear here once you save your first entry.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                HStack(spacing: 16) {
                    statCard(
                        title: "Current streak",
                        value: "\(currentStreak) day\(currentStreak == 1 ? "" : "s")"
                    )
                    
                    statCard(
                        title: "Total dreams",
                        value: "\(dreamStore.entries.count)"
                    )
                }
            }
        }
    }
    
    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    // MARK: - Recent Dreams
    
    private var recentDreamsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent dreams")
                    .font(.headline)
                Spacer()
            }
            
            if dreamStore.entries.isEmpty {
                Text("Once you start logging, your most recent dreams will show up here for quick access.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                let recent = Array(dreamStore.entries.prefix(3))
                
                ForEach(recent) { entry in
                    recentDreamCard(entry: entry)
                }
            }
        }
    }
    
    private func recentDreamCard(entry: DreamEntry) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(entry.dreamDate, style: .date)
                Text("•")
                Text(dreamTypeLabel(for: entry))
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Text(entry.text)
                .font(.subheadline)
                .lineLimit(3)
            
            if entry.isNightmare {
                Text("Nightmare")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.1))
                    )
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    // MARK: - Logic helpers
    
    /// Simple streak: counts consecutive days (including today or yesterday) that have at least one dream.
    private var currentStreak: Int {
        let calendar = Calendar.current
        
        // Unique days with dreams
        let days: [Date] = Array(
            Set(
                dreamStore.entries.map { calendar.startOfDay(for: $0.dreamDate) }
            )
        ).sorted()
        
        guard let lastDay = days.last else { return 0 }
        
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // Streak only counts if the latest entry is today or yesterday
        if lastDay != today && lastDay != yesterday {
            return 0
        }
        
        var streak = 1
        var current = lastDay
        var index = days.count - 1
        
        while index > 0 {
            let prev = days[index - 1]
            if let expectedPrev = calendar.date(byAdding: .day, value: -1, to: current),
               calendar.isDate(prev, inSameDayAs: expectedPrev) {
                streak += 1
                current = prev
                index -= 1
            } else {
                break
            }
        }
        
        return streak
    }
    
    /// Lightweight dream type label for the recent list.
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

// MARK: - Fun Fact Model

struct DreamFact: Identifiable {
    let id = UUID()
    let title: String
    let text: String
}

extension DreamFact {
    static let sampleFacts: [DreamFact] = [
        DreamFact(
            title: "Most dreams vanish fast",
            text: "Researchers estimate we forget up to 80–90% of our dreams within a few minutes of waking up."
        ),
        DreamFact(
            title: "You dream every night",
            text: "Even if you don’t remember them, your brain cycles through multiple REM periods and can create 4–6 dreams each night."
        ),
        DreamFact(
            title: "Feelings first, logic later",
            text: "Dreams are often built around emotions more than realistic plots—your mind uses strange stories to match how you feel."
        )
    ]
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(DreamStore())
    }
}

