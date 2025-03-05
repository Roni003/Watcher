//
//  ReminderComponent.swift
//  active-reminders-frontend
//
//  Created by Ronik on 13/02/2025.
//

import SwiftUI
import Foundation

struct ReminderRowView: View {
  @State var reminder: Reminder
  var onChange: () -> Void
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        if reminder.description != "" {
          Text(reminder.description)
        }
        if reminder.trigger != nil {
          HStack {
            Image(systemName: reminder.trigger!.iconName)
            Text(reminder.trigger!.displayText)
              .foregroundStyle(.gray)
              .bold()
          }
        }
      }
      Spacer()
      if (!self.reminder.enabled) {
        Text("Disabled").font(.subheadline).bold()
      }
    }
    .opacity(self.reminder.enabled ? 1.0 : 0.5)
    .padding(6.0)
    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
    .shadow(radius: 0.5)
    .swipeActions() {
      Button("Delete", systemImage: "trash") {
        Task {
          do {
            try await deleteReminder(reminder.id)
            onChange()  // Refresh only after deletion completes
          } catch {
            print("Error deleting reminder: \(error.localizedDescription)")
          }
        }
      }
      .tint(.red)
    }
    .onTapGesture {
      self.reminder.enabled.toggle()
      Task {
        do {
          if (try await toggleReminderEnabled(reminder: reminder)) {
            print("Toggled reminder \(reminder.description)")
          }
          onChange()
        } catch {
          print("Error toggling reminder: \(error.localizedDescription)")
        }
      }
    }
  }
}
