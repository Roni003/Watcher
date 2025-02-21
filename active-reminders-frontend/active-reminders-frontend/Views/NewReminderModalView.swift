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
  
  @State private var description: String = ""
  @State private var selectedTrigger: TriggerType? = nil  // Track the selected trigger
  @State private var showAlert = false
  
  private var inputBoxBackgroundColor = Color(UIColor(hexCode: "#303031", alpha: 1))
  private var backgroundColor = Color(UIColor(hexCode: "#1C1C1E", alpha: 1))
  private var inputBoxPadding = 10
  private var inputBoxCornerRadius = 8
  
  // Add all trigger types in the order you want them displayed
  private let triggerTypes: [TriggerType] = [
    .weather,
    .traffic,
    .tfl,
    .groceryStore,
    .pharmacy,
    .customLocation
  ]
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Button(action: {
          dismiss()
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
          handleCreate()
          if(validate()) {
            dismiss()
          } else {
            showAlert = true
          }
        }
        .foregroundColor(.blue)
        .font(.headline)
        .alert(isPresented: $showAlert) {
          Alert(
            title: Text("A reminder must have a description or a trigger!"),
            dismissButton: .default(Text("OK"))
          )
        }
      }

      TextField("Description", text: $description)
        .padding(CGFloat(inputBoxPadding))
        .background(inputBoxBackgroundColor)
        .cornerRadius(CGFloat(inputBoxCornerRadius))
        .bold()
      
      // -----------------------
      // |      TRIGGERS       |
      // -----------------------
  
      VStack(alignment: .leading, spacing: 12) {
        Text("Choose a trigger (optional)")
          .font(.headline)
          .bold()
        
        ForEach(triggerTypes, id: \.self) { triggerType in
          TriggerToggleView(
            triggerType: triggerType,
            isSelected: selectedTrigger == triggerType,
            onSelect: {
              // Toggle selection
              if selectedTrigger == triggerType {
                selectedTrigger = nil
              } else {
                selectedTrigger = triggerType
              }
            }
          )
        }
    
      }
      // Spacer to push trigger list up top
      Spacer()
    }
    .padding()
  }
  
  func handleCreate() {
    let description = self.description
    let trigger = selectedTrigger
    
    print(description, trigger)
  }
  
  func validate() -> Bool {
    return self.description != "" || (selectedTrigger != nil)
  }
}
