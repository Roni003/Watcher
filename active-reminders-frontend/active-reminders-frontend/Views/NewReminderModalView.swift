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
  var onReminderCreated: () -> Void
  
  init(onReminderCreated: @escaping () -> Void) {
    self.onReminderCreated = onReminderCreated
  }
  
  @State private var showAlert = false
  @State private var alertTitle: String = ""
  @State private var description: String = ""
  @State private var selectedTrigger: TriggerType? = nil  // Track the selected trigger
  @State private var selectedTrainLine: TrainLine? = nil // Track the TFL line if TFL trigger is selected.
  
  var inputBoxBackgroundColor = Color(UIColor(hexCode: "#303031", alpha: 1))
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
//    .customLocation
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
            title: Text(alertTitle),
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
              if selectedTrigger == triggerType {
                selectedTrigger = nil
              } else {
                selectedTrigger = triggerType
              }
            }
          )
          if self.selectedTrigger == triggerType {
            Text(triggerType.descriptionText)
              .font(.footnote)
              .foregroundStyle(.gray)
              .bold()
          }
        }
        
        if selectedTrigger == .tfl {
          VStack(alignment: .leading, spacing: 8) {
            Text("Select Train Line")
              .font(.headline)
              .bold()
              .padding(.top, 12)
            
            ScrollView(.vertical, showsIndicators: true) {
              VStack(spacing: 8) {
                ForEach(TrainLine.allCases, id: \.self) { trainLine in
                  Button(action: {
                    selectedTrainLine = selectedTrainLine == trainLine ? nil : trainLine
                  }) {
                    HStack {
                      Circle()
                        .fill(trainLine.color)
                        .frame(width: 12, height: 12)
                      
                      Text(trainLine.rawValue)
                        .foregroundColor(.primary)
                      
                      Spacer()
                      
                      if selectedTrainLine == trainLine {
                        Image(systemName: "checkmark")
                          .foregroundColor(.blue)
                      }
                    }
                    .padding(CGFloat(inputBoxPadding))
                    .background(inputBoxBackgroundColor)
                    .cornerRadius(CGFloat(inputBoxCornerRadius))
                  }
                }
              }
            }
            .frame(maxHeight: 200)
          }
        }
      }
      
      // Spacer to push trigger list up top
      Spacer()
    }
    .padding()
  }
  
  func handleCreate() {
    Task {
      do {
        let success = try await createReminder(
          description: description,
          trigger: selectedTrigger,
          trainLine: selectedTrainLine
        )
        
        await MainActor.run {
          if success {
            onReminderCreated()
            dismiss()
          }
        }
      }
    }
  }
  
  func validate() -> Bool {
    if (self.selectedTrigger == TriggerType.tfl && self.selectedTrainLine == nil) {
      alertTitle = "A TFL reminder must have a train line selected!"
      return false
    }
    
    if (self.description != "" || selectedTrigger != nil) {
      return true
    } else {
      self.alertTitle = "A reminder must have a description or a trigger!"
      return false
    }
  }
}
