//
//  InsightsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/20/25.
//

import SwiftUI

struct InsightsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dream Insights")
                .font(.title3)
                .bold()
            Text("Here you’ll eventually see patterns in your dreams—recurring themes, atmospheres, emotions, and symbolic interpretations.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Insights")
    }
}

#Preview {
    NavigationStack {
        InsightsView()
            .environmentObject(DreamStore())
    }
}

