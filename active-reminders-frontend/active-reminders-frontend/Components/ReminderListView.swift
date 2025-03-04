//
//  ReminderListView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 13/02/2025.
//

import Foundation
import SwiftUI

struct ReminderListView: View {
  var reminders: [Reminder]
  var onDelete: () -> Void
  
  var body: some View {
    List(reminders) { reminder in
      ReminderRowView(reminder: reminder, onDelete: self.onDelete)
    }
    .contentMargins(10)
  }
}
