//
//  PatchUserRequest.swift
//  active-reminders-frontend
//
//  Created by Ronik on 22/02/2025.
//

import Foundation

struct PatchUserRequest: Codable {
  var radius: Int?
  var fetch_interval: Int?
}
