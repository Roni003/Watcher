//
//  ReminderUtils.swift
//  active-reminders-frontend
//
//  Created by Ronik on 25/02/2025.
//

import Foundation

func triggerReminders(reminders: [Reminder]) {
  for reminder in reminders {
    triggerReminder(reminder: reminder)
  }
}

private func triggerReminder(reminder: Reminder) {
  sendNotificationForReminder(reminder: reminder)
  Task {
//    try await deleteReminder(reminder.id)
  }
}
