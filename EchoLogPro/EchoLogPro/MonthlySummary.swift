//
//  MonthlySummary.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import Foundation
import SwiftUI

struct MonthlySummary: Codable, Identifiable {
    let date: String // YYYY-MM format
    let categoryDistribution: [String: Double]
    let moodColor: String
    let actionSummary: String
    let environmentalImpact: EnvironmentalImpact
    let generativeAPIKeywords: [String]
    let nextGoal: String
    
    var id: String { date }
    
    enum CodingKeys: String, CodingKey {
        case date
        case categoryDistribution = "category_distribution"
        case moodColor = "moodColor"
        case actionSummary = "actionSummary"
        case environmentalImpact = "environmental_impact"
        case generativeAPIKeywords = "generative_api_keywords"
        case nextGoal = "nextGoal"
    }
    
    var color: Color {
        Color(hex: moodColor) ?? .gray
    }
    
    var dominantCategory: SustainabilityCategory? {
        guard let maxEntry = categoryDistribution.max(by: { $0.value < $1.value }) else {
            return nil
        }
        return SustainabilityCategory.allCases.first { $0.rawValue == maxEntry.key }
    }
}

struct EnvironmentalImpact: Codable {
    let statement: String
    let category: String
}
