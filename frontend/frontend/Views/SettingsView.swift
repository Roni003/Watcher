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
  @State private var locationManager: LocationManagerModel
  @State private var isBatterySaverModeEnabled = true

  
  private var defaultRadius = 200
  private var defaultInterval = 180
  private var minimumInterval = 30
  
  private let fontSize: CGFloat = 20
  private var inputBoxBackgroundColor = Color(UIColor(hexCode: "#303031", alpha: 1))
  
  init(locationManager: LocationManagerModel) {
    self.locationManager = locationManager;
  }

  var body: some View {
    VStack(alignment: .leading , spacing: 12) {
      Text("Email")
        .font(.system(size: fontSize))
        .bold()
      Text(email)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(inputBoxBackgroundColor)
        .cornerRadius(8)
        .bold()
      
      Text("Trigger Radius (meters)")
        .font(.system(size: fontSize))
        .bold()
      TextField("Radius" + radiusString, text: $radiusString)
        .padding(12)
        .background(inputBoxBackgroundColor)
        .cornerRadius(8)
        .bold()
      
      Text("Check-Trigger Interval (seconds)")
        .font(.system(size: fontSize))
        .bold()
      TextField("Seconds", text: $fetchIntervalString)
        .padding(12)
        .background(inputBoxBackgroundColor)
        .cornerRadius(8)
        .bold()

      Toggle(isOn: $isBatterySaverModeEnabled) {
        Text("Battery Saver Mode")
          .font(.system(size: fontSize - 2))
      }
      .padding(8)
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
        .bold()
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
      self.isBatterySaverModeEnabled = data.battery_saver_mode
      self.email = currentUser.email ?? "?"
    } catch {
      debugPrint(error)
    }
  }
  
  func updateSettings() async {
    let radius: Int = Int(self.radiusString) ?? defaultRadius
    var fetchInterval: Int = Int(self.fetchIntervalString) ?? defaultInterval
    fetchInterval = max(fetchInterval, minimumInterval)
    let patchRequest = PatchUserRequest(radius: radius, fetch_interval: fetchInterval, battery_saver_mode: self.isBatterySaverModeEnabled)
    
    self.locationManager.setUpdateInterval(TimeInterval(fetchInterval))
    self.locationManager.setBatterySaverMode(self.isBatterySaverModeEnabled)
    Task {
      let req = try await patchUser(updatedBody: patchRequest)
    }
  }
}
