//
//  ReminderService.swift
//  active-reminders-frontend
//
//  Created by Ronik on 13/02/2025.
//

import Foundation

let AUTH_TOKEN_HEADER_KEY = "ar-auth-token"

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
  request.setValue(token, forHTTPHeaderField: AUTH_TOKEN_HEADER_KEY)
  
  let (data, response) = try await URLSession.shared.data(for: request)
  
  if let jsonString = String(data: data, encoding: .utf8) {
//    print("Raw JSON response: \(jsonString)")
  }
  
  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    throw NSError(domain: "APIError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch reminders"])
  }
  
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601 // Fixes Date decoding issue ? hopefully
  return try decoder.decode([Reminder].self, from: data)
}

func deleteReminder(_ id: String) async throws {
  guard let url = URL(string: SERVER_URL + "/reminders/\(id)") else {
    throw URLError(.badURL)
  }
  
  // Create a URLRequest and specify the HTTP method as DELETE.
  var request = URLRequest(url: url)
  request.httpMethod = "DELETE"
  request.setValue(await getAuthToken(), forHTTPHeaderField: AUTH_TOKEN_HEADER_KEY)
  
  // Perform the request asynchronously.
  let (_, response) = try await URLSession.shared.data(for: request)
  
  // Check the response status code.
  guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
    throw URLError(.badServerResponse)
  }
}

func createReminder(description: String, trigger: TriggerType? = nil, trainLine: TrainLine? = nil) async throws -> Bool {
  guard let url = URL(string: "\(SERVER_URL)/reminders") else {
    throw URLError(.badURL)
  }
  
  // Create the request with the correct format
  let requestData = CreateReminderRequest(
    description: description,
    triggerType: trigger,
    trainLine: trainLine
  )
  
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue(await getAuthToken(), forHTTPHeaderField: AUTH_TOKEN_HEADER_KEY)
  
  let encoder = JSONEncoder()
  request.httpBody = try encoder.encode(requestData)
  
  let (_, response) = try await URLSession.shared.data(for: request)
  
  guard let httpResponse = response as? HTTPURLResponse else {
    throw URLError(.badServerResponse)
  }
  
  return httpResponse.statusCode == 201 || httpResponse.statusCode == 200
}

func sendTriggerCheck(location: Location) {
  print(location)
}
