//
//  MeView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct MeView: View {
    var body: some View {
        Text("Your dream diary")
            .padding()
            .navigationTitle("Me")
    }
}

#Preview {
    NavigationStack {
        MeView()
    }
}
