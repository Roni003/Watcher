//
//  ReminderService.swift
//  active-reminders-frontend
//
//  Created by Ronik on 13/02/2025.
//

import Foundation

func fetchReminders() async throws -> [Reminder] {
  guard let token = await getAuthToken() else {
    throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No auth token available"])
  }
  
  guard let url = URL(string: SERVER_URL + "/reminders") else {
    throw NSError(domain: "URLError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
  }
  
  var request = URLRequest(url: url)
  request.httpMethod = "GET"
  request.setValue("application/json", forHTTPHeaderField: "Accept")
  request.setValue(token, forHTTPHeaderField: "ar-auth-token")
  
  let (data, response) = try await URLSession.shared.data(for: request)
  
  if let jsonString = String(data: data, encoding: .utf8) {
//    print("Raw JSON response: \(jsonString)")
  }
  
  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    throw NSError(domain: "APIError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch reminders"])
  }
  
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601 // Fixes Date decoding issue ? hopefullys
  return try decoder.decode([Reminder].self, from: data)
}
