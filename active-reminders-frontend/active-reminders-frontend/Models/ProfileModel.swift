//
//  ProfileModel.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation

struct Profile: Decodable {
    let email: String?
    //let blacklist

    enum CodingKeys: String, CodingKey {
        case email
    }
}
