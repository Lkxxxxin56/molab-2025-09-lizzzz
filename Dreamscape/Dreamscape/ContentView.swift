//
//  ContentView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical")
            }
            
            NavigationStack {
                AddEntryView()
            }
            .tabItem {
                Label("New Entry", systemImage: "plus.circle")
            }
            
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "globe")
            }
            
            NavigationStack {
                MeView()
            }
            .tabItem {
                Label("Me", systemImage: "person.crop.circle")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(DreamStore())
}
