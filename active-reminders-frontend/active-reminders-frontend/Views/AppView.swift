//
//  AppView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI
import CoreLocation

struct AppView: View {
  @State var isAuthenticated = false

  var body: some View {
    Group {
      if isAuthenticated {
          NavigationStack {
            DashboardView()
          }
      } else {
        AuthView()
      }
    }
    .onAppear {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
          print("Notification authorization error: \(error)")
        }
        if granted {
          print("Use accepted notification permissions.")
        } else {
          print("User denied notification permissions.")
        }
      }
    }
    .task {
      for await state in supabase.auth.authStateChanges {
        if [.initialSession, .signedIn, .signedOut].contains(state.event) {
          isAuthenticated = state.session != nil
        }
      }
    }
  }
}
