//
//  ContentView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            TabView(selection: $selectedTab) {
                HomeView(viewModel: viewModel)
                    .tag(0)
                
                JournalListView(viewModel: viewModel)
                    .tag(1)
                
                InsightsView(viewModel: viewModel)
                    .tag(2)
                
                ProfileView(viewModel: viewModel)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            TabBarButton(
                icon: "book.fill",
                title: "Journal",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            TabBarButton(
                icon: "chart.bar.fill",
                title: "Insights",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
            
            TabBarButton(
                icon: "person.fill",
                title: "Profile",
                isSelected: selectedTab == 3,
                action: { selectedTab = 3 }
            )
        }
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.cardBackground)
        .cornerRadius(AppRadius.lg)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primaryGreen : AppColors.textSecondary)
                
                Text(title)
                    .font(AppTypography.small)
                    .foregroundColor(isSelected ? AppColors.primaryGreen : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
        }
    }
}

#Preview {
    ContentView()
}
