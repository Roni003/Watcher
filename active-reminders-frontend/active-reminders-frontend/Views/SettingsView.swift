//
//  SettingsView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
  @State private var radiusString: String = ""
  @State private var fetchIntervalString: String = ""
  @State private var email: String = ""
  
  private var inputBoxBackgroundColor = Color(UIColor(hexCode: "#303031", alpha: 1))


  var body: some View {
    VStack(alignment: .leading , spacing: 12) {
      Text("Email")
        .foregroundStyle(.secondary)
        .font(.system(size: 22))
        .bold()
      Text(email)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(inputBoxBackgroundColor)
        .cornerRadius(8)
        .bold()
      
      Text("Trigger Radius")
        .foregroundStyle(.secondary)
        .font(.system(size: 22))
        .bold()
      TextField("Radius:" + radiusString, text: $radiusString)
        .padding(12)
        .background(inputBoxBackgroundColor)
        .cornerRadius(8)
        .bold()
      
      Text("Check-Trigger Interval")
        .foregroundStyle(.secondary)
        .font(.system(size: 22))
        .bold()
      TextField("Seconds", text: $fetchIntervalString)
        .padding(12)
        .background(inputBoxBackgroundColor)
        .cornerRadius(8)
        .bold()
      
      
      Spacer()
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
      await getInitialSettings()
    }
    .onDisappear {
      Task {
        await updateSettings()
      }
    }
  }
  
  
  func getInitialSettings() async {
    do {
      let currentUser = try await supabase.auth.session.user
      
      let data: User = try await supabase.from("users")
        .select()
        .eq("id", value: currentUser.id)
        .single()
        .execute()
        .value
        
      
      self.radiusString = String(data.radius)
      self.fetchIntervalString = String(data.fetch_interval)
      self.email = currentUser.email ?? "?"
    } catch {
      debugPrint(error)
    }
  }
  
  func updateSettings() async {
      
  }
}


#Preview {
    SettingsView()
}
