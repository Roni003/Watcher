//
//  TriggerTypes.swift
//  active-reminders-frontend
//
//  Created by Ronik on 13/02/2025.
//

import Foundation

enum TriggerType: String, Codable {
  case weather
  case traffic
  case tfl
  case groceryStore
  case pharmacy
  case customLocation
}

extension TriggerType {
  var iconName: String {
    switch self {
    case .weather:
      return "cloud.rain.fill"
    case .traffic:
      return "car.fill"
    case .tfl:
      return "train.side.front.car"
    case .groceryStore:
      return "storefront.fill"
    case .pharmacy:
      return "pill.fill"
    case .customLocation:
      return "location.square.fill"
    }
  }
  
  var displayText: String {
    switch self {
    case .weather:
      return "Bad Weather"
    case .traffic:
      return "Heavy Traffic"
    case .tfl:
      return "TFL Delays"
    case .groceryStore:
      return "Grocery Stores"
    case .pharmacy:
      return "Pharmacies"
    case .customLocation:
      return "Custom Location"
    }
  }
}
