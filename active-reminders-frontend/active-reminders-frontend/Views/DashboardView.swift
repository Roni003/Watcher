//
//  DashboardView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct DashboardView: View {
  @Environment(\.scenePhase) private var scenePhase
  @Environment(\.colorScheme) var colorScheme
  @StateObject var reminderViewModel = ReminderViewModel()
  @State private var showModal = false // State variable to control modal visibility
  private var locationManager = LocationManagerModel()

  private var REGULAR_REMINDERS_MAX_HEIGHT = 275
  private var newReminderButtonFontSize = 22
  
  var body: some View {
    VStack() {
      if reminderViewModel.isEmpty() {
        Text("No reminders or alerts created yet")
          .padding(.vertical, 20)
          .foregroundColor(.secondary)
          .bold()
          .font(.subheadline)
      }

      if !reminderViewModel.getRegularReminders().isEmpty {
        ReminderListView(reminders: reminderViewModel.getRegularReminders(), onChange: {
          Task {
            await reminderViewModel.loadReminders()
          }
        }, title: "Regular Reminders")
        .frame(height: min(CGFloat(REGULAR_REMINDERS_MAX_HEIGHT), CGFloat(reminderViewModel.getRegularReminders().count * 45 + 50)))
      }
    
      if !reminderViewModel.getAlertReminders().isEmpty {
        ReminderListView(reminders: reminderViewModel.getAlertReminders(), onChange: {
          Task {
            await reminderViewModel.loadReminders()
          }
        }, title: "Alerts")
      }
      
      Spacer()
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
          NavigationLink(destination: SettingsView(locationManager: self.locationManager)) {
              Image(systemName: "gearshape")
                  .foregroundColor(.blue)
          }
      }
    })
    .onAppear() {
      Task {
        await self.reminderViewModel.loadReminders()
      }
    }
    .sheet(isPresented: $showModal) { // Show modal when showModal is true
      NewReminderModalView(locationManager: self.locationManager, onReminderCreated: {
        Task {
          await self.reminderViewModel.loadReminders()
        }
      })
    }
    .onChange(of: scenePhase) { oldPhase, newPhase in
      switch newPhase {
      case .active:
        Task {
          await self.reminderViewModel.loadReminders()
        }
        locationManager.updateAppState(isInForeground: true)
      case .background:
        locationManager.updateAppState(isInForeground: false)
      case .inactive:
        locationManager.updateAppState(isInForeground: false)
      @unknown default:
        break
      }
    }
  }
}

#Preview {
  DashboardView()
}
