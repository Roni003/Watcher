//
//  AuthUtils.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation

let SERVER_URL = "http://localhost:3000/api"

func getAuthToken() async -> String? {
    do {
        let token = try await supabase.auth.session.accessToken
      print("Auth token: " + token)
        return token
    } catch {
        print("Error getting access token: \(error)")
        return nil
    }
}
