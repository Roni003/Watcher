//
//  TriggerToggleView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 21/02/2025.
//

import Foundation
import SwiftUI

struct TriggerToggleView: View {
  let triggerType: TriggerType
  let isSelected: Bool
  let onSelect: () -> Void
  
  var toggleBackgroundColor = Color(UIColor(hexCode: "#303031", alpha: 1))
  var togglePadding = 12
  var toggleCornerRadius = 8
  
  var body: some View {
    Button(action: onSelect) {
      HStack {
        Image(systemName: triggerType.iconName)
          .foregroundColor(isSelected ? .blue : .primary)
        
        Text(triggerType.displayText)
          .foregroundColor(isSelected ? .blue : .primary)
        
        Spacer()
        
        if isSelected {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .padding(CGFloat(togglePadding))
      .background(toggleBackgroundColor)
      .cornerRadius(CGFloat(toggleCornerRadius))
    }
  }
}
