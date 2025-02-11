//
//  DashboardView.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import SwiftUI

struct DashboardView: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Dashboard")
        .font(.largeTitle)
    }
    .padding()
    .navigationTitle("Dashboard")
    .toolbar(content: {
        ToolbarItem(placement: .topBarTrailing){
          NavigationLink(destination: ProfileView()) {
              Image(systemName: "gearshape")
                  .foregroundColor(.blue)
          }
      }
    })
  }
}

