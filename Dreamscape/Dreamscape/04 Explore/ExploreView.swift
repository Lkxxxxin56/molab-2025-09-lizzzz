//
//  ExploreView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct ExploreView: View {
    private let posts = DreamPost.sampleData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Optional intro text
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dream Feed")
                            .font(.title2)
                            .bold()
                        Text("See how other dreamers describe their nights.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    
                    ForEach(posts) { post in
                        DreamPostCard(post: post)
                    }
                    
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Post Card

struct DreamPostCard: View {
    let post: DreamPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: avatar + name + date
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(post.avatarColor)
                        .frame(width: 42, height: 42)
                    
                    Text(post.initials)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(.subheadline)
                        .bold()
                    HStack(spacing: 6) {
                        Text(post.date, style: .date)
                        Text("•")
                        Text(post.isNightmare ? "Nightmare" : "Dream")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Title + snippet
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                Text(post.snippet)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Visual placeholder
            ZStack(alignment: .bottomLeading) {
                postGradient
                    .frame(height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dream visual placeholder")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    Text("“\(post.visualPrompt)”")
                        .font(.caption2.italic())
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(10)
            }
            
            // Tags
            if !post.tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(post.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.08))
                            )
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Footer actions (non-functional for now)
            HStack(spacing: 18) {
                Label("\(post.likeCount)", systemImage: "heart")
                Label("\(post.commentCount)", systemImage: "bubble.right")
                Spacer()
                Image(systemName: "square.and.arrow.up")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .dreamCardStyle()
        .padding(.horizontal)
    }
    
    // Gradient based on atmosphere-ish vibe
    private var postGradient: LinearGradient {
        switch post.vibe {
        case .warm:
            return LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .dark:
            return LinearGradient(colors: [.purple, .black], startPoint: .top, endPoint: .bottom)
        case .surreal:
            return LinearGradient(colors: [.purple, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .neon:
            return LinearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .calm:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

// MARK: - Model

struct DreamPost: Identifiable {
    enum Vibe {
        case warm, dark, surreal, neon, calm
    }
    
    let id = UUID()
    let authorName: String
    let initials: String
    let avatarColor: Color
    let title: String
    let snippet: String
    let visualPrompt: String
    let tags: [String]
    let date: Date
    let isNightmare: Bool
    let vibe: Vibe
    let likeCount: Int
    let commentCount: Int
}

// MARK: - Sample Data

extension DreamPost {
    static let sampleData: [DreamPost] = [
        DreamPost(
            authorName: "Lena",
            initials: "L",
            avatarColor: Color.purple,
            title: "Train made of glass over the ocean",
            snippet: "I took a midnight train where the floor and walls were made of glass. The tracks floated above a dark, endless ocean. Every time the train bent around a curve, I could see my reflection in the water below, like dozens of versions of me watching back.",
            visualPrompt: "Glass train curving over a dark ocean at night, reflections in the water",
            tags: ["Train", "Water", "Reflection"],
            date: Date().addingTimeInterval(-60 * 60 * 24 * 1), // 1 day ago
            isNightmare: false,
            vibe: .surreal,
            likeCount: 23,
            commentCount: 5
        ),
        DreamPost(
            authorName: "Noah",
            initials: "N",
            avatarColor: Color.blue,
            title: "Running through an empty school forever",
            snippet: "I was late for an exam but every classroom I opened was the wrong one. The hallways stretched endlessly and my old locker number kept changing. Outside, I could see a storm forming, but no one else was there.",
            visualPrompt: "Endless school hallway with flickering lights and storm clouds outside the windows",
            tags: ["School", "Storm", "Being Chased"],
            date: Date().addingTimeInterval(-60 * 60 * 24 * 3), // 3 days ago
            isNightmare: true,
            vibe: .dark,
            likeCount: 41,
            commentCount: 12
        ),
        DreamPost(
            authorName: "Mira",
            initials: "M",
            avatarColor: Color.orange,
            title: "A tiny house in a forest of giant books",
            snippet: "I lived in a small wooden house surrounded by towering books instead of trees. To visit friends, I had to climb the spines and jump from book to book. Every time I opened a page, the weather changed.",
            visualPrompt: "Cozy cabin in a forest of giant books, pages turning into changing skies",
            tags: ["House", "Forest", "Books"],
            date: Date().addingTimeInterval(-60 * 60 * 24 * 6), // 6 days ago
            isNightmare: false,
            vibe: .warm,
            likeCount: 35,
            commentCount: 7
        ),
        DreamPost(
            authorName: "Kai",
            initials: "K",
            avatarColor: Color.green,
            title: "Floating above a neon city",
            snippet: "I was slowly drifting above a neon city at 3AM. Billboards were showing scenes from my own memories, but with other people playing me. I couldn’t go down or up — just drift at the same height.",
            visualPrompt: "Person floating above neon-lit city at night, billboards showing their memories",
            tags: ["City", "Flying", "Neon"],
            date: Date().addingTimeInterval(-60 * 60 * 24 * 9), // 9 days ago
            isNightmare: false,
            vibe: .neon,
            likeCount: 52,
            commentCount: 18
        ),
        DreamPost(
            authorName: "Aria",
            initials: "A",
            avatarColor: Color.pink,
            title: "Talking to my shadow on a bridge",
            snippet: "I stood on a bridge at sunset and my shadow started talking back to me. It knew things I hadn’t told anyone, and each time it spoke, the bridge extended further into the fog.",
            visualPrompt: "Person on a bridge at sunset, their shadow speaking, bridge extending into fog",
            tags: ["Bridge", "Shadow", "Fog"],
            date: Date().addingTimeInterval(-60 * 60 * 24 * 11), // 11 days ago
            isNightmare: false,
            vibe: .calm,
            likeCount: 44,
            commentCount: 10
        )
    ]
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}

