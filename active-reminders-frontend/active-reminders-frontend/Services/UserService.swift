//
//  UserService.swift
//  active-reminders-frontend
//
//  Created by Ronik on 22/02/2025.
//
import Foundation

func patchUser(updatedBody: PatchUserRequest) async throws -> Bool {
  guard let url = URL(string: SERVER_URL + "/users") else {
    throw URLError(.badURL)
  }
  
  // Create a URLRequest and specify the HTTP method as DELETE.
  var request = URLRequest(url: url)
  request.httpMethod = "PATCH"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue(await getAuthToken(), forHTTPHeaderField: AUTH_TOKEN_HEADER_KEY)
  
  let encoder = JSONEncoder()
  request.httpBody = try encoder.encode(updatedBody)
  
  let (_, response) = try await URLSession.shared.data(for: request)
  
  guard let httpResponse = response as? HTTPURLResponse else {
    throw URLError(.badServerResponse)
  }
  
  return httpResponse.statusCode == 201 || httpResponse.statusCode == 200
}
