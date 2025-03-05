import SwiftUI
import Foundation

class ReminderViewModel: ObservableObject {
  @Published var reminders: [Reminder] = []
  
  func loadReminders() async {
    do {
      let fetchedReminders = try await fetchReminders()
      await MainActor.run {
        withAnimation {
          self.reminders = self.sortReminders(reminderList: fetchedReminders)
        }
      }
    } catch {
      print("Error fetching reminders: \(error.localizedDescription)")
    }
  }
  
  func sortReminders(reminderList: [Reminder]) -> [Reminder] {
    return reminderList.sorted { $0.enabled && !$1.enabled }
  }
}
