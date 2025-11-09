//
//  SustainabilityCategory.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import Foundation
import SwiftUI

enum SustainabilityCategory: String, Codable, CaseIterable, Identifiable {
    case recyclingWaste = "Recycling & Waste"
    case waterConservation = "Water Conservation"
    case energyUse = "Energy Use"
    case transportation = "Transportation"
    case foodConsumption = "Food & Consumption"
    case fashionShopping = "Fashion & Shopping"
    case mindsetAwareness = "Mindset / Awareness"
    
    var id: String { rawValue }
    
    var persona: String {
        switch self {
        case .recyclingWaste:
            return "The Reclaimer"
        case .waterConservation:
            return "The Refresher"
        case .energyUse:
            return "The Charger"
        case .transportation:
            return "The Mover"
        case .foodConsumption:
            return "The Feeder"
        case .fashionShopping:
            return "The Dresser"
        case .mindsetAwareness:
            return "The Thinker"
        }
    }
    
    var icon: String {
        switch self {
        case .recyclingWaste:
            return "arrow.3.trianglepath"
        case .waterConservation:
            return "drop.fill"
        case .energyUse:
            return "bolt.fill"
        case .transportation:
            return "bicycle"
        case .foodConsumption:
            return "leaf.fill"
        case .fashionShopping:
            return "bag.fill"
        case .mindsetAwareness:
            return "brain.head.profile"
        }
    }
    
    var color: Color {
        switch self {
        case .recyclingWaste:
            return Color.green
        case .waterConservation:
            return Color.blue
        case .energyUse:
            return Color.yellow
        case .transportation:
            return Color.orange
        case .foodConsumption:
            return Color.mint
        case .fashionShopping:
            return Color.purple
        case .mindsetAwareness:
            return Color.indigo
        }
    }
    
    var description: String {
        switch self {
        case .recyclingWaste:
            return "Actions related to recycling, composting, waste reduction, and proper disposal"
        case .waterConservation:
            return "Activities focused on saving water, reducing water waste, and protecting water resources"
        case .energyUse:
            return "Efforts to reduce energy consumption, use renewable energy, and improve energy efficiency"
        case .transportation:
            return "Sustainable transportation choices like biking, walking, public transit, or carpooling"
        case .foodConsumption:
            return "Sustainable eating habits, reducing food waste, local/organic food choices, plant-based meals"
        case .fashionShopping:
            return "Conscious shopping, secondhand purchases, sustainable fashion, and reducing consumption"
        case .mindsetAwareness:
            return "Educational activities, advocacy, reflection, and raising awareness about sustainability"
        }
    }
}
