//
//  ReminderModel.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation

struct Location: Codable {
  let lat: Double
  let lon: Double
}

// Custom Location Metadata
struct CustomLocationMetadata: Codable {
  let location: Location
}

// TFL (Transport for London) Metadata
struct TflMetadata: Codable {
  let line: String
}

enum ReminderMetadata: Codable {
  case customLocation(CustomLocationMetadata)
  case tfl(TflMetadata)
  
  enum MetadataKeys: String, CodingKey {
    case line
    case location
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MetadataKeys.self)
    switch self {
    case .tfl(let tflMetadata):
      try container.encode(tflMetadata.line, forKey: .line)
    case .customLocation(let customLocationMetadata):
      // When encoding, encode the inner Location directly
      try container.encode(customLocationMetadata.location, forKey: .location)
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MetadataKeys.self)
    
    if container.contains(.line) {
      let line = try container.decode(String.self, forKey: .line)
      self = .tfl(TflMetadata(line: line))
      return
    }
    
    if container.contains(.location) {
      // Decode a Location directly rather than a CustomLocationMetadata.
      let location = try container.decode(Location.self, forKey: .location)
      self = .customLocation(CustomLocationMetadata(location: location))
      return
    }
    
    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                            debugDescription: "Invalid metadata object"))
  }
}

// Main Reminder struct
struct Reminder: Codable, Identifiable {
  let id: String
  let userId: String
  let description: String
  var enabled: Bool
  let createdAt: String
  let updatedAt: String
  var trigger: TriggerType?
  var metadata: ReminderMetadata?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case userId = "user_id"
    case enabled
    case description
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case trigger
    case metadata
  }
}
