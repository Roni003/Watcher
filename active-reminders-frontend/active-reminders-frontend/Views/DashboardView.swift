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
    .task {
        await fetchReminders()
    }
  }
    
    func fetchReminders() async {
        // Fetch from server by sending token in auth url
        let token = await getAuthToken()
        print(token)
        if token == nil {
            return
        }
        
        let url = URL(string: SERVER_URL + "/reminders")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // or "POST", "PUT", "DELETE", etc.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("ar-auth-token", forHTTPHeaderField: token!)
    }
}

