//
//  DiaryView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/20/25.
//

import SwiftUI

struct DiaryView: View {
    @EnvironmentObject var dreamStore: DreamStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if dreamStore.entries.isEmpty {
                    Text("You haven’t saved any dreams yet.\nYour dream stories will appear here after saving them from the summary page.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    ForEach(dreamStore.entries) { entry in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(entry.text)
                                .font(.subheadline)
                                .lineLimit(2)
                            
                            HStack(spacing: 8) {
                                Text(entry.dreamDate, style: .date)
                                if entry.isNightmare {
                                    Text("Nightmare")
                                        .foregroundColor(.red)
                                }
                                Text(entry.atmosphere)
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dream Diary")
    }
}

#Preview {
    NavigationStack {
        DiaryView()
            .environmentObject(DreamStore())
    }
}
