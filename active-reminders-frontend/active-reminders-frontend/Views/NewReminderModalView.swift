//
//  NewReminderModalView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 21/02/2025.
//

import Foundation
import SwiftUI

struct NewReminderModalView: View {
  @Environment(\.dismiss) var dismiss
  
  // State to store the description and trigger selections
  @State private var description: String = ""
  @State private var isBadWeather: Bool = false
  @State private var isHighTraffic: Bool = false
  @State private var isTFLDelays: Bool = false
  @State private var isGroceryStoreNearby: Bool = false
  @State private var isDrugStoreNearby: Bool = false
  @State private var isCustomLocation: Bool = false
  
//  private var color = "#303031"
//  private var backgroundColor = "#1C1C1E"
  private var toggleBackgroundColor = Color(UIColor(hexCode: "#303031", alpha: 1))
  private var backgroundColor = Color(UIColor(hexCode: "#1C1C1E", alpha: 1))
  private var togglePadding = 10
  private var toggleCornerRadius = 8
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Button(action: {
          dismiss() // Dismiss modal
        }) {
          HStack {
            Image(systemName: "chevron.backward")
            Text("Cancel")
          }
        }
        .foregroundColor(.red)
        .font(.headline)
        
        Spacer()
        
        Button("Create") {
          // Create reminder logic (add logic here)
          dismiss() // Dismiss modal after creating
        }
        .foregroundColor(.blue)
        .font(.headline)
      }

      TextField("Description", text: $description)
        .padding(10)
        .background(toggleBackgroundColor)
        .cornerRadius(CGFloat(toggleCornerRadius))
        .bold()
//        .textFieldStyle(RoundedBorderTextFieldStyle())

      
      // -----------------------
      // |      TRIGGERS       |
      // -----------------------
  
      VStack(alignment: .leading, spacing: 12) {
        Text("Choose a trigger (optional)")
          .font(.headline)
          .bold()
        
        Section {
          Toggle(isOn: $isBadWeather) {
            HStack {
              Image(systemName: TriggerType.weather.iconName)
              Text(TriggerType.weather.displayText)
            }
          }
          .toggleStyle(SwitchToggleStyle(tint: .green))
          .bold()
        }
        .padding(CGFloat(self.togglePadding))
        .background(toggleBackgroundColor)
        .cornerRadius(CGFloat(self.toggleCornerRadius))
        
        Section {
          Toggle(isOn: $isHighTraffic) {
            HStack {
              Image(systemName: TriggerType.traffic.iconName)
              Text(TriggerType.traffic.displayText)
            }
          }
          .toggleStyle(SwitchToggleStyle(tint: .green))
          .bold()
        }
        .padding(CGFloat(self.togglePadding))
        .background(toggleBackgroundColor)
        .cornerRadius(CGFloat(self.toggleCornerRadius))
        
        Section {
          Toggle(isOn: $isTFLDelays) {
            HStack {
              Image(systemName: TriggerType.tfl.iconName)
              Text(TriggerType.tfl.displayText)
            }
          }
          .toggleStyle(SwitchToggleStyle(tint: .green))
          .bold()
        }
        .padding(CGFloat(self.togglePadding))
        .background(toggleBackgroundColor)
        .cornerRadius(CGFloat(self.toggleCornerRadius))
        
        Section {
          Toggle(isOn: $isGroceryStoreNearby) {
            HStack {
              Image(systemName: TriggerType.groceryStore.iconName)
              Text(TriggerType.groceryStore.displayText)
            }
          }
          .toggleStyle(SwitchToggleStyle(tint: .green))
          .bold()
        }
        .padding(CGFloat(self.togglePadding))
        .background(toggleBackgroundColor)
        .cornerRadius(CGFloat(self.toggleCornerRadius))
      }
      // Spacer to push trigger list up top
      Spacer()
    }
    .padding()
  }
}
