//
//  JournalListView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI

struct JournalListView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var selectedCategory: SustainabilityCategory?
    
    var filteredEntries: [JournalEntry] {
        if let category = selectedCategory {
            return viewModel.entries.filter { $0.category == category }
        }
        return viewModel.entries
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Journal")
                            .font(AppTypography.largeTitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, AppSpacing.md)
                    
                    // Category Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.sm) {
                            CategoryPill(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(SustainabilityCategory.allCases) { category in
                                CategoryPill(
                                    title: category.rawValue,
                                    icon: category.icon,
                                    color: category.color,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    .padding(.bottom, AppSpacing.md)
                    
                    // Entries List
                    if filteredEntries.isEmpty {
                        EmptyJournalView()
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: AppSpacing.md) {
                                ForEach(groupedEntries.keys.sorted(by: >), id: \.self) { date in
                                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                        Text(formatDate(date))
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                            .padding(.horizontal, AppSpacing.lg)
                                            .padding(.top, AppSpacing.sm)
                                        
                                        ForEach(groupedEntries[date] ?? []) { entry in
                                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                                JournalEntryCard(entry: entry)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.bottom, AppSpacing.xxl)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    var groupedEntries: [String: [JournalEntry]] {
        Dictionary(grouping: filteredEntries) { entry in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: entry.timestamp)
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE, MMM d"
            return outputFormatter.string(from: date)
        }
    }
}

struct CategoryPill: View {
    let title: String
    var icon: String? = nil
    var color: Color = AppColors.primaryGreen
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(AppTypography.caption)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? color : AppColors.cardBackground)
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            .cornerRadius(AppRadius.md)
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Time
            VStack(spacing: 2) {
                Text(entry.timestamp, style: .time)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Circle()
                    .fill(entry.category.color)
                    .frame(width: 6, height: 6)
            }
            .frame(width: 60)
            
            // Content
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Image(systemName: entry.category.icon)
                        .font(.title3)
                        .foregroundColor(entry.category.color)
                    
                    Text(entry.category.rawValue)
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    // Mood indicator
                    Text(moodEmoji(entry.moodScore))
                        .font(.title3)
                }
                
                if let caption = entry.userCaption {
                    Text(caption)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                } else if let transcribed = entry.transcribedText {
                    Text(transcribed)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }
                
                // Confidence badge
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                        .foregroundColor(entry.categoryConfidence > 0.8 ? AppColors.primaryGreen : AppColors.accentOrange)
                    
                    Text(String(format: "%.0f%% confident", entry.categoryConfidence * 100))
                        .font(AppTypography.small)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(.vertical, AppSpacing.sm)
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
    
    func moodEmoji(_ score: Double) -> String {
        if score >= 0.5 { return "😊" }
        else if score >= 0.0 { return "🙂" }
        else if score >= -0.5 { return "😐" }
        else { return "😔" }
    }
}

struct EmptyJournalView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryGreen.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryGreen)
            }
            
            Text("No Entries Yet")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text("Start logging your sustainable actions\nto see them here")
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    JournalListView(viewModel: JournalViewModel())
}
