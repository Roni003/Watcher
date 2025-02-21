//
//  CreateReminderRequest.swift
//  active-reminders-frontend
//
//  Created by Ronik on 21/02/2025.
//

import Foundation

struct CreateReminderRequest: Codable {
  let description: String
  let trigger: String?
  let metadata: [String: String]?
  
  init(description: String, triggerType: TriggerType? = nil, trainLine: TrainLine? = nil) {
    self.description = description
    self.trigger = triggerType?.rawValue
    
    // Only include metadata if we have a train line for TFL trigger
    // TODO: do this for custom location as well
    if triggerType == .tfl && trainLine != nil {
      self.metadata = ["line": trainLine!.rawValue.lowercased()]
    } else {
      self.metadata = nil
    }
  }
}
