//
//  ExploreView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        Text("Explore other dreamscapes")
            .padding()
            .navigationTitle("Explore")
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
