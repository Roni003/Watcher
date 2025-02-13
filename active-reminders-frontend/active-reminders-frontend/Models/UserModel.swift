//
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation

// Most user info is stored in auth.users, this is extra metadata in public.users
struct User: Codable {
//  let blacklist
  let radius: Int32; // meters
}
