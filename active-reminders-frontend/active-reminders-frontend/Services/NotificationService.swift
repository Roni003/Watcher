//
//  NotificationService.swift
//  active-reminders-frontend
//
//  Created by Ronik on 25/02/2025.
//

import Foundation
import UserNotifications

func sendNotificationForReminder(reminder: Reminder) {
  print("Notification for reminder: \(reminder.description) sent")
  let content = UNMutableNotificationContent()
  
  content.title = "Active Reminders"
  content.body = "\(reminder.description) - \(reminder.trigger?.displayText ?? "")"
  
  content.sound = .default
  
  // TODO: add actions such as click to open map
  content.categoryIdentifier = "REMINDER_CATEGORY"
  
  let request = UNNotificationRequest(
    identifier: UUID().uuidString,
    content: content,
    trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
  )
  
  UNUserNotificationCenter.current().add(request) { error in
    if let error = error {
      print("Error scheduling notification: \(error)")
    }
  }
}
