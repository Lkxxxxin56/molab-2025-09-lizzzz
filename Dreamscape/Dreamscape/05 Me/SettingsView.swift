//
//  SettingsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/20/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                Text("Change Display Name (coming soon)")
                Text("Change Profile Photo (coming soon)")
            }
            
            Section(header: Text("App Settings")) {
                Text("Appearance")
                Text("Backup & Sync (future Firebase)")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(DreamStore())
    }
}
