//
//  ReminderUtils.swift
//  active-reminders-frontend
//
//  Created by Ronik on 25/02/2025.
//

import Foundation

func triggerReminders(reminderMessagePairs: [ReminderMessagePair]) {
  for reminder in reminderMessagePairs {
    triggerReminder(reminderMessagePair: reminder)
  }
}

private func triggerReminder(reminderMessagePair: ReminderMessagePair) {
  sendNotificationForReminder(reminderMessagePair: reminderMessagePair)
  Task {
//    try await deleteReminder(reminderMessagePair.reminder.id) TODO: uncomment after testing
  }
}
