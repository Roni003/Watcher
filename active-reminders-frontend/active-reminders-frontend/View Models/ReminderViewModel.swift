//
//  ReminderViewModel.swift
//  active-reminders-frontend
//
//  Created by Ronik on 05/03/2025.
//

import SwiftUI
import Foundation

class ReminderViewModel: ObservableObject {
  @Published var reminders: [Reminder] = []
  
  // This function performs the async fetch of reminders.
  func loadReminders() async {
    do {
      let fetchedReminders = try await fetchReminders()
      // Ensure that UI updates are made on the main thread.
      await MainActor.run {
        withAnimation {
          self.reminders = fetchedReminders
        }
      }
    } catch {
      print("Error fetching reminders: \(error.localizedDescription)")
    }
  }
}
