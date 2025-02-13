//
//  ProfileView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
  @State var email = ""
  @State var radius = 200

  @State var isLoading = false

  var body: some View {
    VStack(spacing: 20) {
      Text("Settings")
        .font(.largeTitle)
    }
    .padding()
    .navigationTitle("Settings")
    .toolbar(content: {
        ToolbarItem(placement: .topBarTrailing){
        Button("Sign out", role: .destructive) {
          Task {
            try? await supabase.auth.signOut()
          }
        }
        .foregroundColor(.red)
      }
    })
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


#Preview {
    SettingsView()
}
