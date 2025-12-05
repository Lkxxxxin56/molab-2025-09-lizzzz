//
//  FactualQuestionsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/14/25.
//

import SwiftUI

struct FactualQuestionsView: View {
//    @State private var dreamDate: Date = Date()
//    @State private var isNightmare: Bool = false
//    @State private var wokeYouUp: Bool = false
//    @State private var clarity: Double = 0.5
//    @State private var intensity: Double = 0.5
    @ObservedObject var draft: DreamDraft
    
    var body: some View {
        Form {
            // Q1: Dream date
            Section(header: Text("Dream Date")) {
                DatePicker("When did you have this dream?",
                           selection: $draft.dreamDate,
                           displayedComponents: .date)
            }
            
            Section(header: Text("Factual Details")) {
                // Q2: Nightmare yes/no
                Toggle("Was it a nightmare?", isOn: $draft.isNightmare)
                
                // Q3: Wake up yes/no
                Toggle("Did it wake you up from sleep?", isOn: $draft.wokeYouUp)
                
                // Q4: Memory clarity slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Memory clarity")
                        Spacer()
                        Text(clarityLabel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $draft.clarity, in: 0...1)
                    HStack {
                        Text("Blurry")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Vivid")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                // Q5: Dream intensity slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Dream intensity")
                        Spacer()
                        Text(intensityLabel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $draft.clarity, in: 0...1)
                    HStack {
                        Text("Calm")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Intense")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section {
                NavigationLink {
                    EmotionalQuestionsView(draft: draft)
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .bold()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .navigationTitle("Step 2: Facts")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var clarityLabel: String {
        switch draft.clarity {
        case 0..<0.25:
            return "Very blurry"
        case 0.25..<0.5:
            return "Blurry"
        case 0.5..<0.75:
            return "Quite clear"
        default:
            return "Very vivid"
        }
    }
    
    private var intensityLabel: String {
        switch draft.clarity {
        case 0..<0.25:
            return "Very intense"
        case 0.25..<0.5:
            return "Intense"
        case 0.5..<0.75:
            return "Quite calm"
        default:
            return "Very calm"
        }
    }
}

#Preview {
    NavigationStack {
        FactualQuestionsView(draft: DreamDraft())
    }
}

