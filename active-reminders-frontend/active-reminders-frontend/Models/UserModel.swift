//
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation

// Most user info is stored in auth.users, this is extra metadata in public.users
struct User: Codable {
  let id: String
  let radius: Int32; // meters
  let fetch_interval: Int32; 
  let blacklist: [String:String]?
  let created_at: String
  let updated_at: String?
}
