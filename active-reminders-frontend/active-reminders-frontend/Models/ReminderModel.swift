//
//  ReminderModel.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Reminder: Codable, Identifiable {
    let id: String
    let description: String
    let date: Date
    // Optional fields
    let location: Location?
    let trigger: TriggerType?
}

