//
//  JournalViewModel.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var monthlySummaries: [MonthlySummary] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private let userId: UUID
    
    init() {
        // Get or create user ID
        if let savedUserId = UserDefaults.standard.string(forKey: "userId"),
           let uuid = UUID(uuidString: savedUserId) {
            self.userId = uuid
        } else {
            self.userId = UUID()
            UserDefaults.standard.set(self.userId.uuidString, forKey: "userId")
        }
        
        // Load sample data for demo purposes
        loadSampleData()
    }
    
    // MARK: - Entry Management
    
    func addEntry(
        mediaData: Data,
        mediaType: MediaType,
        userCaption: String? = nil,
        location: LocationData? = nil
    ) async {
        isLoading = true
        errorMessage = nil
        
        // Demo mode: Create entry without API call
        // In production, uncomment the API calls below
        
        // For demo, randomly select a category or use a simple heuristic
        let demoCategory = selectDemoCategory(caption: userCaption, mediaType: mediaType)
        
        let entry = JournalEntry(
            userId: userId,
            location: location,
            mediaType: mediaType,
            mediaURL: "local://\(UUID().uuidString).\(mediaType.fileExtension)",
            category: demoCategory,
            categoryConfidence: Double.random(in: 0.8...0.98),
            moodScore: Double.random(in: 0.5...0.9),
            transcribedText: mediaType == .audio ? "[Audio transcription would appear here]" : nil,
            userCaption: userCaption
        )
        
        // Add to local state
        entries.insert(entry, at: 0)
        
        isLoading = false
        
        /* PRODUCTION CODE - Uncomment when backend is ready:
        do {
            // Step 1: Classify the media
            let classification = try await apiService.classifyMedia(
                mediaData: mediaData,
                mediaType: mediaType,
                userCaption: userCaption
            )
            
            // Step 2: Upload media to storage
            let mediaURL = "local://\(UUID().uuidString).\(mediaType.fileExtension)"
            
            // Step 3: Create journal entry
            let entry = JournalEntry(
                userId: userId,
                location: location,
                mediaType: mediaType,
                mediaURL: mediaURL,
                category: classification.category,
                categoryConfidence: classification.confidence,
                moodScore: classification.moodScore,
                transcribedText: classification.transcribedText,
                userCaption: userCaption
            )
            
            // Step 4: Save to backend
            try await apiService.createEntry(entry)
            
            // Step 5: Update local state
            entries.insert(entry, at: 0)
            
            // Step 6: Refresh monthly summary
            await refreshCurrentMonthSummary()
            
        } catch {
            errorMessage = "Failed to add entry: \(error.localizedDescription)"
        }
        
        isLoading = false
        */
    }
    
    // Demo helper to select category based on caption keywords
    private func selectDemoCategory(caption: String?, mediaType: MediaType) -> SustainabilityCategory {
        guard let caption = caption?.lowercased() else {
            return SustainabilityCategory.allCases.randomElement() ?? .mindsetAwareness
        }
        
        if caption.contains("recycle") || caption.contains("trash") || caption.contains("waste") || caption.contains("compost") {
            return .recyclingWaste
        } else if caption.contains("water") || caption.contains("shower") || caption.contains("faucet") {
            return .waterConservation
        } else if caption.contains("energy") || caption.contains("light") || caption.contains("electric") || caption.contains("solar") {
            return .energyUse
        } else if caption.contains("bike") || caption.contains("walk") || caption.contains("bus") || caption.contains("transit") || caption.contains("carpool") {
            return .transportation
        } else if caption.contains("food") || caption.contains("meal") || caption.contains("plant") || caption.contains("vegan") || caption.contains("local") {
            return .foodConsumption
        } else if caption.contains("shop") || caption.contains("clothes") || caption.contains("fashion") || caption.contains("secondhand") || caption.contains("thrift") {
            return .fashionShopping
        } else {
            return .mindsetAwareness
        }
    }
    
    func fetchEntries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            entries = try await apiService.fetchEntries(userId: userId)
        } catch {
            errorMessage = "Failed to fetch entries: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Monthly Summary
    
    func refreshCurrentMonthSummary() async {
        let currentMonth = getCurrentMonthString()
        
        do {
            let summary = try await apiService.generateMonthlySummary(
                userId: userId,
                month: currentMonth
            )
            
            // Update or add summary
            if let index = monthlySummaries.firstIndex(where: { $0.date == currentMonth }) {
                monthlySummaries[index] = summary
            } else {
                monthlySummaries.insert(summary, at: 0)
            }
        } catch {
            errorMessage = "Failed to generate summary: \(error.localizedDescription)"
        }
    }
    
    func fetchMonthlySummaries() async {
        // Fetch summaries for the last 6 months
        let calendar = Calendar.current
        let currentDate = Date()
        
        for i in 0..<6 {
            if let date = calendar.date(byAdding: .month, value: -i, to: currentDate) {
                let monthString = formatMonthForAPI(date)
                
                do {
                    let summary = try await apiService.fetchMonthlySummary(
                        userId: userId,
                        month: monthString
                    )
                    
                    if !monthlySummaries.contains(where: { $0.date == monthString }) {
                        monthlySummaries.append(summary)
                    }
                } catch {
                    // Summary might not exist for this month, continue
                    continue
                }
            }
        }
        
        monthlySummaries.sort { $0.date > $1.date }
    }
    
    // MARK: - Helper Methods
    
    private func getCurrentMonthString() -> String {
        formatMonthForAPI(Date())
    }
    
    private func formatMonthForAPI(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }
    
    // MARK: - Sample Data (for demo purposes)
    
    private func loadSampleData() {
        // Create sample entries
        let sampleEntries = [
            JournalEntry(
                userId: userId,
                timestamp: Date().addingTimeInterval(-86400 * 2),
                mediaType: .photo,
                mediaURL: "sample1",
                category: .recyclingWaste,
                categoryConfidence: 0.95,
                moodScore: 0.8,
                userCaption: "Recycled all my plastic bottles today!"
            ),
            JournalEntry(
                userId: userId,
                timestamp: Date().addingTimeInterval(-86400 * 5),
                mediaType: .photo,
                mediaURL: "sample2",
                category: .transportation,
                categoryConfidence: 0.88,
                moodScore: 0.9,
                userCaption: "Biked to work instead of driving"
            ),
            JournalEntry(
                userId: userId,
                timestamp: Date().addingTimeInterval(-86400 * 7),
                mediaType: .audio,
                mediaURL: "sample3",
                category: .waterConservation,
                categoryConfidence: 0.92,
                moodScore: 0.7,
                transcribedText: "Installed a low-flow showerhead to save water",
                userCaption: nil
            ),
            JournalEntry(
                userId: userId,
                timestamp: Date().addingTimeInterval(-86400 * 10),
                mediaType: .photo,
                mediaURL: "sample4",
                category: .foodConsumption,
                categoryConfidence: 0.85,
                moodScore: 0.85,
                userCaption: "Made a delicious plant-based meal"
            )
        ]
        
        entries = sampleEntries
        
        // Create sample monthly summary
        let sampleSummary = MonthlySummary(
            date: getCurrentMonthString(),
            categoryDistribution: [
                "Recycling & Waste": 30.0,
                "Water Conservation": 20.0,
                "Energy Use": 10.0,
                "Transportation": 25.0,
                "Food & Consumption": 15.0,
                "Fashion & Shopping": 0.0,
                "Mindset / Awareness": 0.0
            ],
            moodColor: "#4CAF50",
            actionSummary: "This month you've been amazing! You logged 20 sustainable actions with a strong focus on recycling and transportation. Your commitment to biking and proper waste disposal is making a real difference.",
            environmentalImpact: EnvironmentalImpact(
                statement: "30% increase in recycling actions this month",
                category: "Recycling & Waste"
            ),
            generativeAPIKeywords: ["recycling", "transportation", "sustainability", "eco-friendly"],
            nextGoal: "Try to focus on energy use next month!"
        )
        
        monthlySummaries = [sampleSummary]
    }
}
