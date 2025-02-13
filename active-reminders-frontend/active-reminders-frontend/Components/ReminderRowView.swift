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
    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
    .padding(8.0)
    .background(.gray.opacity(0.2))
    .swipeActions() {
      Button("Delete", systemImage: "trash") {
        print("Deleting reminder \(reminder.id)")
      }
      .tint(.red)
    }
  }
}
