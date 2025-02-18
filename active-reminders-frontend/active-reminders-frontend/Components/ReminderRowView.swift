//
//  ReminderComponent.swift
//  active-reminders-frontend
//
//  Created by Ronik on 13/02/2025.
//

import SwiftUI
import Foundation

struct ReminderRowView: View {
  var reminder: Reminder
  
  var body: some View {
    VStack {
      Text(reminder.description)
      if reminder.trigger != nil {
        HStack {
          Image(systemName: reminder.trigger!.iconName)
          Text(reminder.trigger!.displayText)
        }
      }
    }
    .padding(8.0)
    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
    .swipeActions() {
      Button("Delete", systemImage: "trash") {
        deleteReminder(reminder)
      }
      .tint(.red)
    }
  }
}

func deleteReminder(_ reminder: Reminder) {
  print("Deleting reminder \(reminder.id)...")
  Task {
    try await deleteReminder(reminder.id)
  }
}
