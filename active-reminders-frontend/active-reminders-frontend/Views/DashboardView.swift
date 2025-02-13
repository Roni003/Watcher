//
//  DashboardView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct DashboardView: View {
  @State var reminders: [Reminder] = []
  
  var body: some View {
    VStack(spacing: 20) {
      ReminderListView(reminders: self.reminders)
    }
    .padding()
    .navigationTitle("Dashboard")
    .toolbar(content: {
        ToolbarItem(placement: .topBarTrailing){
            NavigationLink(destination: SettingsView()) {
              Image(systemName: "gearshape")
                  .foregroundColor(.blue)
          }
      }
    })
    .task {
      await loadReminders()
    }
  }
    
  func loadReminders() async {
    do {
      let fetchedReminders = try await fetchReminders()
      DispatchQueue.main.async {
        self.reminders = fetchedReminders
      }
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
}

#Preview {
  DashboardView()
}
