//
//  APIService.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()
    
    // TODO: Replace with your actual backend API URL
    private let baseURL = "https://your-backend-api.com/api"
    
    private init() {}
    
    // MARK: - Media Classification
    
    func classifyMedia(
        mediaData: Data,
        mediaType: MediaType,
        userCaption: String? = nil
    ) async throws -> ClassificationResult {
        let url = URL(string: "\(baseURL)/classify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add media file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"media\"; filename=\"media.\(mediaType.fileExtension)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mediaType.mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(mediaData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add media type
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"media_type\"\r\n\r\n".data(using: .utf8)!)
        body.append(mediaType.rawValue.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add user caption if available
        if let caption = userCaption {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"user_caption\"\r\n\r\n".data(using: .utf8)!)
            body.append(caption.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let result = try JSONDecoder().decode(ClassificationResult.self, from: data)
        return result
    }
    
    // MARK: - Journal Entry Management
    
    func createEntry(_ entry: JournalEntry) async throws {
        let url = URL(string: "\(baseURL)/entries")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(entry)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw APIError.invalidResponse
        }
    }
    
    func fetchEntries(userId: UUID) async throws -> [JournalEntry] {
        let url = URL(string: "\(baseURL)/entries?user_id=\(userId.uuidString)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let entries = try decoder.decode([JournalEntry].self, from: data)
        return entries
    }
    
    // MARK: - Monthly Summary
    
    func fetchMonthlySummary(userId: UUID, month: String) async throws -> MonthlySummary {
        let url = URL(string: "\(baseURL)/summary?user_id=\(userId.uuidString)&month=\(month)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let summary = try JSONDecoder().decode(MonthlySummary.self, from: data)
        return summary
    }
    
    func generateMonthlySummary(userId: UUID, month: String) async throws -> MonthlySummary {
        let url = URL(string: "\(baseURL)/summary/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["user_id": userId.uuidString, "month": month]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let summary = try JSONDecoder().decode(MonthlySummary.self, from: data)
        return summary
    }
}

// MARK: - Supporting Types

struct ClassificationResult: Codable {
    let category: SustainabilityCategory
    let confidence: Double
    let moodScore: Double
    let transcribedText: String?
    
    enum CodingKeys: String, CodingKey {
        case category
        case confidence
        case moodScore = "mood_score"
        case transcribedText = "transcribed_text"
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError
    case decodingError
}

extension MediaType {
    var fileExtension: String {
        switch self {
        case .photo: return "jpg"
        case .video: return "mp4"
        case .audio: return "m4a"
        }
    }
    
    var mimeType: String {
        switch self {
        case .photo: return "image/jpeg"
        case .video: return "video/mp4"
        case .audio: return "audio/m4a"
        }
    }
}
