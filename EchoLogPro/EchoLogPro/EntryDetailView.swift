//
//  EntryDetailView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI
import MapKit

struct EntryDetailView: View {
    let entry: JournalEntry
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {
                    // Media Preview
                    if entry.mediaType == .photo || entry.mediaType == .video {
                        AsyncImage(url: URL(string: entry.mediaURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(AppColors.primaryGreen.opacity(0.2))
                                .overlay(
                                    VStack {
                                        Image(systemName: entry.mediaType == .photo ? "photo" : "video")
                                            .font(.system(size: 50))
                                            .foregroundColor(AppColors.primaryGreen)
                                        
                                        ProgressView()
                                            .tint(AppColors.primaryGreen)
                                    }
                                )
                        }
                        .frame(height: 300)
                        .clipped()
                        .cornerRadius(AppRadius.lg)
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    // Category Badge
                    HStack(spacing: AppSpacing.md) {
                        Image(systemName: entry.category.icon)
                            .font(.title2)
                            .foregroundColor(entry.category.color)
                            .frame(width: 60, height: 60)
                            .background(entry.category.color.opacity(0.2))
                            .cornerRadius(AppRadius.md)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.category.rawValue)
                                .font(AppTypography.title3)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(entry.category.persona)
                                .font(AppTypography.caption)
                                .foregroundColor(entry.category.color)
                        }
                        
                        Spacer()
                    }
                    .padding(AppSpacing.lg)
                    .cardStyle()
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Timestamp and Location
                    VStack(spacing: AppSpacing.md) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(AppColors.primaryGreen)
                                .frame(width: 24)
                            
                            Text(entry.timestamp, style: .date)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("at")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text(entry.timestamp, style: .time)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        
                        if let location = entry.location {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(AppColors.primaryGreen)
                                    .frame(width: 24)
                                
                                Text(String(format: "%.4f, %.4f", location.latitude, location.longitude))
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(AppSpacing.lg)
                    .cardStyle()
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // User Caption or Transcribed Text
                    if let caption = entry.userCaption {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Caption")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(caption)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    if let transcribed = entry.transcribedText {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            HStack {
                                Image(systemName: "waveform")
                                    .foregroundColor(AppColors.primaryGreen)
                                Text("Transcription")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            Text(transcribed)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(6)
                                .padding(AppSpacing.md)
                                .background(AppColors.background)
                                .cornerRadius(AppRadius.sm)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    // Mood and Confidence
                    HStack(spacing: AppSpacing.md) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Mood Score")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack {
                                Text(moodEmoji(entry.moodScore))
                                    .font(.title)
                                
                                Text(String(format: "%.2f", entry.moodScore))
                                    .font(AppTypography.title3)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Confidence")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(entry.categoryConfidence > 0.8 ? AppColors.primaryGreen : AppColors.accentOrange)
                                
                                Text(String(format: "%.0f%%", entry.categoryConfidence * 100))
                                    .font(AppTypography.title3)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        .cardStyle()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Spacer(minLength: AppSpacing.xxl)
                }
                .padding(.top, AppSpacing.md)
            }
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func moodEmoji(_ score: Double) -> String {
        if score >= 0.5 { return "😊" }
        else if score >= 0.0 { return "🙂" }
        else if score >= -0.5 { return "😐" }
        else { return "😔" }
    }
}

#Preview {
    NavigationView {
        EntryDetailView(
            entry: JournalEntry(
                userId: UUID(),
                mediaType: .photo,
                mediaURL: "https://example.com/image.jpg",
                category: .recyclingWaste,
                categoryConfidence: 0.95,
                moodScore: 0.8,
                userCaption: "Recycled all my plastic bottles today!"
            )
        )
    }
}
