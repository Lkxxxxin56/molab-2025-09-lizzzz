//
//  InsightsView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI

struct InsightsView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        HStack {
                            Text("Insights")
                                .font(AppTypography.largeTitle)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppSpacing.xxl)
                        .padding(.top, AppSpacing.lg)
                        
                        if let currentSummary = viewModel.monthlySummaries.first {
                            // Habit Tracker
                            HabitTrackerCard()
                                .padding(.horizontal, AppSpacing.sm)
                            
                            // Stats Grid
                            StatsGridCard(summary: currentSummary, totalEntries: viewModel.entries.count)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            // Category Breakdown
                            CategoryBreakdownCard(summary: currentSummary)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            // Monthly Summary
                            MonthlySummaryCard(summary: currentSummary)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            // Next Goal
                            NextGoalCard(goal: currentSummary.nextGoal)
                                .padding(.horizontal, AppSpacing.lg)
                        } else {
                            EmptyInsightsView()
                        }
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HabitTrackerCard: View {
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let completedDays = [true, true, true, true, false, false, false]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Daily Goal")
                .font(AppTypography.title3)
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: AppSpacing.sm) {
                ForEach(0..<7) { index in
                    VStack(spacing: AppSpacing.sm) {
                        Text(daysOfWeek[index])
                            .font(AppTypography.small)
                            .foregroundColor(AppColors.textSecondary)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: AppRadius.sm)
                                .fill(completedDays[index] ? AppColors.primaryGreen : AppColors.cardBackground)
                                .frame(width: 40, height: 50)
                            
                            if completedDays[index] {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            } else {
                                Text(daysOfWeek[index].prefix(1))
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                    }
                }
            }
        }
        .padding(AppSpacing.sm)
        .cardStyle()
    }
}

struct StatsGridCard: View {
    let summary: MonthlySummary
    let totalEntries: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Dark header
            HStack {
                Text("This Month")
                    .font(AppTypography.title3)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Nov 2025")
                    .font(AppTypography.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(AppSpacing.lg)
            .background(AppColors.darkCard)
            .cornerRadius(AppRadius.lg, corners: [.topLeft, .topRight])
            
            // Stats grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 0) {
                StatBox(number: "\(totalEntries)", label: "Actions", color: AppColors.primaryGreen)
                StatBox(number: "7", label: "Categories", color: AppColors.accentOrange)
                StatBox(number: "25", label: "Streak", color: AppColors.accentYellow)
            }
            .background(AppColors.darkCard)
            .cornerRadius(AppRadius.lg, corners: [.bottomLeft, .bottomRight])
        }
    }
}

struct StatBox: View {
    let number: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(number)
                .font(AppTypography.largeTitle)
                .foregroundColor(color)
            
            Text(label)
                .font(AppTypography.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }
}

struct CategoryBreakdownCard: View {
    let summary: MonthlySummary
    
    var sortedCategories: [(String, Double, Color)] {
        summary.categoryDistribution.compactMap { key, value in
            guard let category = SustainabilityCategory.allCases.first(where: { $0.rawValue == key }),
                  value > 0 else {
                return nil
            }
            return (category.rawValue, value, category.color)
        }
        .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Category Breakdown")
                .font(AppTypography.title3)
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: AppSpacing.md) {
                ForEach(sortedCategories, id: \.0) { item in
                    HStack(spacing: AppSpacing.md) {
                        // Category name
                        Text(item.0)
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 140, alignment: .leading)
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: AppRadius.sm)
                                    .fill(AppColors.background)
                                    .frame(height: 24)
                                
                                RoundedRectangle(cornerRadius: AppRadius.sm)
                                    .fill(item.2)
                                    .frame(width: geometry.size.width * (item.1 / 100), height: 24)
                            }
                        }
                        .frame(height: 24)
                        
                        // Percentage
                        Text(String(format: "%.0f%%", item.1))
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
        }
        .padding(AppSpacing.lg)
        .cardStyle()
    }
}

struct MonthlySummaryCard: View {
    let summary: MonthlySummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(AppColors.primaryGreen)
                Text("AI Summary")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text(summary.actionSummary)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(6)
            
            Divider()
                .padding(.vertical, AppSpacing.sm)
            
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(AppColors.primaryGreen)
                
                Text(summary.environmentalImpact.statement)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textPrimary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.primaryGreen.opacity(0.1))
            .cornerRadius(AppRadius.md)
        }
        .padding(AppSpacing.lg)
        .cardStyle()
    }
}

struct NextGoalCard: View {
    let goal: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "target")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(AppColors.primaryGreen)
                .cornerRadius(AppRadius.md)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Next Goal")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text(goal)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.lg)
        .cardStyle()
    }
}

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryGreen.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryGreen)
            }
            
            Text("No Insights Yet")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text("Add more entries to see\nyour sustainability insights")
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

// Helper extension for selective corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    InsightsView(viewModel: JournalViewModel())
}
