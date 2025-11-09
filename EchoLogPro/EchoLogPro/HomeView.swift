//
//  HomeView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("EchoLog")
                                    .font(AppTypography.largeTitle)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Track Your Impact")
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        
                        // Main Action Card
                        VStack(spacing: 0) {
                            // Decorative shapes
                            ZStack {
                                Circle()
                                    .fill(AppColors.darkCard)
                                    .frame(width: 140, height: 140)
                                    .offset(x: -40, y: -20)
                                
                                Circle()
                                    .fill(AppColors.primaryGreen)
                                    .frame(width: 120, height: 120)
                                    .offset(x: 40, y: 30)
                                
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                            }
                            .frame(height: 200)
                            
                            Text("Start Logging")
                                .font(AppTypography.title1)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.top, AppSpacing.md)
                            
                            Text("Capture your sustainable actions")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.bottom, AppSpacing.lg)
                            
                            // Add Entry Button
                            Button(action: {
                                showingAddEntry = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                    Text("Add Entry")
                                }
                                .pillButton(backgroundColor: AppColors.darkCard, foregroundColor: .white)
                            }
                            .padding(.bottom, AppSpacing.lg)
                        }
                        
                        .padding(.horizontal, AppSpacing.lg)
                        .cardStyle()
                        
                        // Daily Streak Card
                        if let summary = viewModel.monthlySummaries.first {
                            DailyStreakCard(summary: summary)
                                .padding(.horizontal, AppSpacing.lg)
                        }
                        
                        // Recent Actions
//                        if !viewModel.entries.isEmpty {
//                            VStack(alignment: .leading, spacing: AppSpacing.md) {
//                                Text("Recent Actions")
//                                    .font(AppTypography.title3)
//                                    .foregroundColor(AppColors.textPrimary)
//                                    .padding(.horizontal, AppSpacing.lg)
//                                
//                                ScrollView(.horizontal, showsIndicators: false) {
//                                    HStack(spacing: AppSpacing.md) {
//                                        ForEach(viewModel.entries.prefix(6)) { entry in
//                                            RecentActionCard(entry: entry)
//                                        }
//                                    }
//                                    .padding(.horizontal, AppSpacing.lg)
//                                }
//                            }
//                        }
                        
                        // Categories Grid
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Categories")
                                .font(AppTypography.title3)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: AppSpacing.md),
                                GridItem(.flexible(), spacing: AppSpacing.md)
                            ], spacing: AppSpacing.md) {
                                ForEach(SustainabilityCategory.allCases.prefix(4)) { category in
                                    CategoryCard(category: category, count: viewModel.entries.filter { $0.category == category }.count)
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView(viewModel: viewModel)
            }
        }
    }
}

struct DailyStreakCard: View {
    let summary: MonthlySummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Keep it Up")
                    .font(AppTypography.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(AppColors.accentOrange)
                    Text("25 Days")
                        .font(AppTypography.headline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(AppColors.darkCard.opacity(0.5))
                .cornerRadius(AppRadius.md)
            }
            
            Text("Building sustainable habits")
                .font(AppTypography.caption)
                .foregroundColor(.white.opacity(0.8))
            
            // Progress dots
            HStack(spacing: 6) {
                ForEach(0..<7) { index in
                    Circle()
                        .fill(index < 4 ? AppColors.primaryGreen : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, AppSpacing.sm)
        }
        .padding(AppSpacing.lg)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [AppColors.darkCard, AppColors.darkCard.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppRadius.lg)
    }
}

//struct RecentActionCard: View {
//    let entry: JournalEntry
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: AppSpacing.sm) {
//            // Icon
//            ZStack {
//                RoundedRectangle(cornerRadius: AppRadius.md)
//                    .fill(entry.category.color.opacity(0.2))
//                    .frame(width: 60, height: 60)
//                
//                Image(systemName: entry.category.icon)
//                    .font(.title2)
//                    .foregroundColor(entry.category.color)
//            }
//            
//            Text(entry.category.rawValue)
//                .font(AppTypography.caption)
//                .foregroundColor(AppColors.textPrimary)
//                .lineLimit(2)
//                .frame(width: 100, alignment: .leading)
//            
//            Text(entry.timestamp, style: .relative)
//                .font(AppTypography.small)
//                .foregroundColor(AppColors.textSecondary)
//        }
//        .frame(width: 120)
//        .padding(AppSpacing.md)
//        .cardStyle()
//    }
//}

struct CategoryCard: View {
    let category: SustainabilityCategory
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundColor(category.color)
                
                Spacer()
                
                Text("\(count)")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text(category.rawValue)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
}

#Preview {
    HomeView(viewModel: JournalViewModel())
}
