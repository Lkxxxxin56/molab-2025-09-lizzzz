//
//  MeView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct MeView: View {
    @EnvironmentObject var dreamStore: DreamStore
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Header
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(colors: [.purple, .blue],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dreamer")
                                .font(.title3)
                                .bold()
                            Text("Exploring your inner dreamscape")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Vertical Menu
                Section {
                    NavigationLink {
                        DiaryArchiveView()
                    } label: {
                        Label("My Dream Diary", systemImage: "book.closed.fill")
                    }
                    
                    NavigationLink {
                        InsightsView()
                    } label: {
                        Label("Dream Insights", systemImage: "chart.bar.xaxis")
                    }
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Profile & Settings", systemImage: "gearshape.fill")
                    }
                }
            }
            .navigationTitle("Me")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        MeView()
            .environmentObject(DreamStore())
    }
}
