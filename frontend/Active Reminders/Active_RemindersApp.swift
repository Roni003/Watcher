//
//  Active_RemindersApp.swift
//  Active Reminders
//
//  Created by Ronik on 22/01/2025.
//

import SwiftUI


class AppState: ObservableObject {
    @Published var isLoggedIn = false
}

@main
struct Active_RemindersApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                DashboardView().environmentObject(appState)
            } else {
                LoginView().environmentObject(appState)
            }
        }
    }
}

