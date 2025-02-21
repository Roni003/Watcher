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
  @State private var showModal = false // State variable to control modal visibility
  
  private var newReminderButtonFontSize = 24
  
  var body: some View {
    VStack() {
      ReminderListView(reminders: self.reminders, onDelete: {
        Task {
          await self.loadReminders()
        }
      })
      HStack {
        Image(systemName: "plus.app.fill")
        Text("Create new reminder")
      }
      .onTapGesture {
        showModal.toggle()
      }
      .font(.system(size: CGFloat(newReminderButtonFontSize)))
    }
    .padding(2)
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
    .sheet(isPresented: $showModal) { // Show modal when showModal is true
      NewReminderModalView()
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
