//
//  Login.swift
//  Active Reminders
//
//  Created by Ronik on 28/01/2025.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Login Page")
            Button("Login") {
                appState.isLoggedIn = true
            }
        }
        .padding()

    }
}

#Preview {
    LoginView()
}
