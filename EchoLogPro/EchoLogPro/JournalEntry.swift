//
//  JournalEntry.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import Foundation
import CoreLocation

enum MediaType: String, Codable {
    case photo
    case video
    case audio
}

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let timestamp: Date
    let location: LocationData?
    let mediaType: MediaType
    let mediaURL: String
    let category: SustainabilityCategory
    let categoryConfidence: Double
    let moodScore: Double
    let transcribedText: String?
    let userCaption: String?
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        timestamp: Date = Date(),
        location: LocationData? = nil,
        mediaType: MediaType,
        mediaURL: String,
        category: SustainabilityCategory,
        categoryConfidence: Double,
        moodScore: Double,
        transcribedText: String? = nil,
        userCaption: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.timestamp = timestamp
        self.location = location
        self.mediaType = mediaType
        self.mediaURL = mediaURL
        self.category = category
        self.categoryConfidence = categoryConfidence
        self.moodScore = moodScore
        self.transcribedText = transcribedText
        self.userCaption = userCaption
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "entry_id"
        case userId = "user_id"
        case timestamp
        case location
        case mediaType = "media_type"
        case mediaURL = "media_url"
        case category
        case categoryConfidence = "category_confidence"
        case moodScore = "mood_score"
        case transcribedText = "transcribed_text"
        case userCaption = "user_caption"
    }
}

struct LocationData: Codable {
    let latitude: Double
    let longitude: Double
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
