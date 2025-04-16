//
//  TriggerCheckRequest.swift
//  active-reminders-frontend
//
//  Created by Ronik on 24/02/2025.
//

import Foundation

struct TriggerCheckRespone: Codable {
  var reminders: [ReminderMessagePair]
}

struct ReminderMessagePair: Codable {
  var reminder: Reminder
  var message: String
}
