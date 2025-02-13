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
        await fetchReminders()
    }
  }
    
  func fetchReminders() async {
    // Fetch from server by sending token in auth url
    let token = await getAuthToken()
    print(token)
    if token == nil {
        return
    }
    
    let url = URL(string: SERVER_URL + "/reminders")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET" // or "POST", "PUT", "DELETE", etc.
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("ar-auth-token", forHTTPHeaderField: token!)
    
    // Set self.reminders
    let exampleReminder = Reminder(id: "id-1", description: "This is an example reminder.", date: Date(), location: nil, trigger: nil)
    
    self.reminders.removeAll()
    self.reminders.append(exampleReminder)
  }
}

#Preview {
  DashboardView()
}
