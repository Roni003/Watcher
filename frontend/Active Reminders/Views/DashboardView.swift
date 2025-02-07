//
//  DashboardView.swift
//  Active Reminders
//
//  Created by Ronik on 28/01/2025.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Dashboard")
            Button("Logout") {
                appState.isLoggedIn = false
            }
        }
        .padding()

    }
}

#Preview {
    DashboardView()
}
