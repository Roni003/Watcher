//
//  NotificationService.swift
//  active-reminders-frontend
//
//  Created by Ronik on 25/02/2025.
//

import Foundation
import UserNotifications

func sendNotificationForReminder(reminderMessagePair: ReminderMessagePair) {
  let reminder = reminderMessagePair.reminder
  let message = reminderMessagePair.message
  
  print("Notification for reminder: \(reminder.description) sent")
  let content = UNMutableNotificationContent()
  
  content.title = "\(reminder.description)"
  content.body = "\(reminder.trigger?.displayText ?? "") - \(message)"
  content.sound = reminder.trigger?.notificationSound
  
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
