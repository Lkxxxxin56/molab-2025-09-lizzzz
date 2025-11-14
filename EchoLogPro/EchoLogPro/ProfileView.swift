//
//  ProfileView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: JournalViewModel
    @AppStorage("userName") private var userName = "Eco Warrior"
    
    var totalEntries: Int {
        viewModel.entries.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        HStack {
                            Text("Profile")
                                .font(AppTypography.largeTitle)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        
                        // Profile Card
                        VStack(spacing: AppSpacing.lg) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(AppColors.primaryGreen)
                                    .frame(width: 100, height: 100)
                                
                                Text(userName.prefix(1).uppercased())
                                    .font(AppTypography.largeTitle)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 4) {
                                Text(userName)
                                    .font(AppTypography.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("\(totalEntries) sustainable actions")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            // Stats
                            HStack(spacing: AppSpacing.xl) {
                                ProfileStat(number: "\(totalEntries)", label: "Actions")
                                ProfileStat(number: "\(viewModel.monthlySummaries.count)", label: "Months")
                                ProfileStat(number: "25", label: "Streak")
                            }
                        }
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // Achievements
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Achievements")
                                .font(AppTypography.title3)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: AppSpacing.md) {
                                AchievementBadge(icon: "🏆", label: "First Entry", unlocked: true)
                                AchievementBadge(icon: "🔥", label: "7 Day Streak", unlocked: true)
                                AchievementBadge(icon: "🌟", label: "25 Actions", unlocked: true)
                                AchievementBadge(icon: "🌍", label: "Eco Hero", unlocked: false)
                                AchievementBadge(icon: "💚", label: "Green Heart", unlocked: false)
                                AchievementBadge(icon: "🎯", label: "Goal Master", unlocked: false)
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                        
                        // Category Stats
                        if let mostFrequent = mostFrequentCategory {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Favorite Category")
                                    .font(AppTypography.title3)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                HStack(spacing: AppSpacing.md) {
                                    Image(systemName: mostFrequent.icon)
                                        .font(.system(size: 40))
                                        .foregroundColor(mostFrequent.color)
                                        .frame(width: 80, height: 80)
                                        .background(mostFrequent.color.opacity(0.2))
                                        .cornerRadius(AppRadius.md)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(mostFrequent.rawValue)
                                            .font(AppTypography.headline)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text(mostFrequent.persona)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                        
                                        Text("\(viewModel.entries.filter { $0.category == mostFrequent }.count) actions")
                                            .font(AppTypography.small)
                                            .foregroundColor(mostFrequent.color)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(AppSpacing.lg)
                            .cardStyle()
                            .padding(.horizontal, AppSpacing.lg)
                        }
                        
                        // Menu Items
                        VStack(spacing: AppSpacing.md) {
                            NavigationLink(destination: CategoryGuideView()) {
                                MenuRow(icon: "book.fill", title: "Category Guide", color: AppColors.primaryGreen)
                            }
                            
                            NavigationLink(destination: AboutView()) {
                                MenuRow(icon: "info.circle.fill", title: "About EchoLog", color: AppColors.accentBlue)
                            }
                            
                            Button(action: {}) {
                                MenuRow(icon: "bell.fill", title: "Notifications", color: AppColors.accentOrange)
                            }
                            
                            Button(action: {}) {
                                MenuRow(icon: "gearshape.fill", title: "Settings", color: AppColors.textSecondary)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    var mostFrequentCategory: SustainabilityCategory? {
        let categoryCounts = Dictionary(grouping: viewModel.entries) { $0.category }
            .mapValues { $0.count }
        
        return categoryCounts.max(by: { $0.value < $1.value })?.key
    }
}

struct ProfileStat: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(AppTypography.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text(label)
                .font(AppTypography.small)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

struct AchievementBadge: View {
    let icon: String
    let label: String
    let unlocked: Bool
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(unlocked ? AppColors.primaryGreen.opacity(0.2) : AppColors.background)
                    .frame(width: 60, height: 60)
                
                Text(icon)
                    .font(.system(size: 30))
                    .opacity(unlocked ? 1.0 : 0.3)
            }
            
            Text(label)
                .font(AppTypography.small)
                .foregroundColor(unlocked ? AppColors.textPrimary : AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
}

struct AboutView: View {
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Logo
                    VStack(spacing: AppSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryGreen)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        
                        Text("EchoLog")
                            .font(AppTypography.largeTitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Version 1.0")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AppSpacing.xl)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("About")
                            .font(AppTypography.title3)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("EchoLog is your personal sustainability journaling companion. Track your eco-friendly actions, gain insights into your environmental impact, and build better habits for a sustainable future.")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(6)
                    }
                    .padding(AppSpacing.lg)
                    .cardStyle()
                    
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Features")
                            .font(AppTypography.title3)
                            .foregroundColor(AppColors.textPrimary)
                        
                        FeatureRow(icon: "camera.fill", text: "Capture actions with photos, videos, or voice")
                        FeatureRow(icon: "brain", text: "AI-powered classification")
                        FeatureRow(icon: "chart.bar.fill", text: "Monthly insights and impact tracking")
                        FeatureRow(icon: "target", text: "Personalized goals")
                    }
                    .padding(AppSpacing.lg)
                    .cardStyle()
                    
                    Text("Made with 💚 for the planet")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, AppSpacing.lg)
                }
                .padding(AppSpacing.lg)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(AppColors.primaryGreen)
                .frame(width: 24)
            
            Text(text)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

struct CategoryGuideView: View {
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    ForEach(SustainabilityCategory.allCases) { category in
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            HStack(spacing: AppSpacing.md) {
                                Image(systemName: category.icon)
                                    .font(.title2)
                                    .foregroundColor(category.color)
                                    .frame(width: 50, height: 50)
                                    .background(category.color.opacity(0.2))
                                    .cornerRadius(AppRadius.md)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(category.rawValue)
                                        .font(AppTypography.headline)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text(category.persona)
                                        .font(AppTypography.caption)
                                        .foregroundColor(category.color)
                                }
                                
                                Spacer()
                            }
                            
                            Text(category.description)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(4)
                        }
                        .padding(AppSpacing.lg)
                        .cardStyle()
                    }
                }
                .padding(AppSpacing.lg)
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(viewModel: JournalViewModel())
}
