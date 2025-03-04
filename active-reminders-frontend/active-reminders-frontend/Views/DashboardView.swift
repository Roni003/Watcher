//
//  DashboardView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct DashboardView: View {
  @Environment(\.colorScheme) var colorScheme
  @State var reminders: [Reminder] = []
  @State private var showModal = false // State variable to control modal visibility
  private var locationManager = LocationManagerModel()

  private var newReminderButtonFontSize = 22
  
  var body: some View {
    VStack() {
      ReminderListView(reminders: self.reminders, onDelete: {
        Task {
          await loadReminders()
        }
      })
      HStack {
        Image(systemName: "plus.app.fill")
          .font(.system(size: CGFloat(newReminderButtonFontSize + 4)))
        Text("Create new reminder")
          .font(.system(size: CGFloat(newReminderButtonFontSize)))

      }
      .onTapGesture {
        showModal.toggle()
      }
      .bold()
    }
    .padding(2)
    .navigationTitle("Dashboard")
    .background(colorScheme == .dark ? .black : Color(UIColor.secondarySystemBackground))
    .toolbar(content: {
        ToolbarItem(placement: .topBarTrailing){
            NavigationLink(destination: SettingsView()) {
              Image(systemName: "gearshape")
                  .foregroundColor(.blue)
          }
      }
    })
    .onAppear {
      Task {
        await loadReminders()
      }
    }
    .sheet(isPresented: $showModal) { // Show modal when showModal is true
      NewReminderModalView(onReminderCreated: {
        Task {
          await loadReminders()
        }
      })
    }
  }
    
  func loadReminders() async {
    do {
      let fetchedReminders = try await fetchReminders()
      DispatchQueue.main.async {
        withAnimation {
          self.reminders = fetchedReminders
        }
      }
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
}

#Preview {
  DashboardView()
}
