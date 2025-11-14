//
//  FactualQuestionsView.swift
//  Dreamscape
//
//  Created by Kexin Liu on 11/14/25.
//

import SwiftUI

struct FactualQuestionsView: View {
    @State private var dreamDate: Date = Date()
    @State private var isNightmare: Bool = false
    @State private var wokeYouUp: Bool = false
    @State private var clarity: Double = 0.5 // 0 = blurry, 1 = vivid
    @State private var intensity: Double = 0.5 // 0 = low intensity, 1 = high intensity

    
    var body: some View {
        Form {
            // Q1: Dream date
            Section(header: Text("Dream Date")) {
                DatePicker("When did you have this dream?",
                           selection: $dreamDate,
                           displayedComponents: .date)
            }
            
            Section(header: Text("Factual Details")) {
                // Q2: Nightmare yes/no
                Toggle("Was it a nightmare?", isOn: $isNightmare)
                
                // Q3: Wake up yes/no
                Toggle("Did it wake you up from sleep?", isOn: $wokeYouUp)
                
                // Q4: Memory clarity slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Memory clarity")
                        Spacer()
                        Text(clarityLabel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $clarity, in: 0...1)
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
                    Slider(value: $clarity, in: 0...1)
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
                    EmotionalQuestionsView()
                } label: {
                    Text("Next: Feelings & Atmosphere")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Step 2: Facts")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var clarityLabel: String {
        switch clarity {
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
        switch clarity {
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
        FactualQuestionsView()
    }
}

