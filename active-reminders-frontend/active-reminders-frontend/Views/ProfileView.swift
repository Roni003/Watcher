//
//  ProfileView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct ProfileView: View {
  @State var email = ""

  @State var isLoading = false

  var body: some View {
    NavigationStack {
        Section {
        Text("Email: \(email)")

        Section {
          if isLoading {
            ProgressView()
          }
        }
      }
      .navigationTitle("Profile")
      .toolbar(content: {
        ToolbarItem(placement: .topBarLeading){
          Button("Sign out", role: .destructive) {
            Task {
              try? await supabase.auth.signOut()
            }
          }
        }
      })
    }
    .task {
      await getInitialProfile()
    }
  }

  func getInitialProfile() async {
    do {
      let currentUser = try await supabase.auth.session.user

        self.email = currentUser.email ?? ""

    } catch {
      debugPrint(error)
    }
  }
}
