//
//  LibraryView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct LibraryView: View {
    private let categories = MotifCategory.sampleData

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.motifs) { motif in
                            NavigationLink {
                                MotifDetailView(motif: motif)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: motif.icon)
                                        .font(.title3)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 30)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(motif.name)
                                            .font(.subheadline)
                                            .bold()
                                        Text(motif.shortMeaning)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)

                            }
                        }
                    }
                }
            }
            .navigationTitle("Dream Library")
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
