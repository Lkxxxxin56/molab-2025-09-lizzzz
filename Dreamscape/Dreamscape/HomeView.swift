//
//  HomeView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Dreamscape")
                .font(.largeTitle).bold()
            Text("Home")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
