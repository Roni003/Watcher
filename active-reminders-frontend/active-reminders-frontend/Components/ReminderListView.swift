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
  var onChange: () -> Void
  
  var body: some View {
    List(reminders) { reminder in
      ReminderRowView(reminder: reminder, onChange: self.onChange)
    }
    .contentMargins(10)
  }
}
