//
//  MotifDetailsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 12/3/25.
//

import SwiftUI

struct MotifDetailView: View {
    let motif: Motif
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(motif.name)
                    .font(.largeTitle)
                    .bold()
                
                Text(motif.shortMeaning)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text(motif.longMeaning)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(motif.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NavigationStack {
//        MotifDetailView(
//            motif: Motif(
//                name: "Water",
//                shortMeaning: "Emotions, depth, or the unconscious.",
//                longMeaning: "Calm water, storms, deep oceans, or floods all carry different emotional tones..."
//            )
//        )
//    }
//}
