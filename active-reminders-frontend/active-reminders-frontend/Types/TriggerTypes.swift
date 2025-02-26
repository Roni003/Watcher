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
//  case customLocation
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
//    case .customLocation:
//      return "location.square.fill"
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
//    case .customLocation:
//      return "Custom Location"
    }
  }
  
  var descriptionText: String {
    switch self {
    case .weather:
      return "This reminder will trigger when there is rain, snow, storms in your area."
    case .traffic:
      return "This reminder will trigger when there is heavy traffic in your area."
    case .tfl:
      return "This reminder will trigger when there are delays or distruptions on the line you choose."
    case .groceryStore:
      return "This reminder will trigger when there is a grocery store near your location."
    case .pharmacy:
      return "This reminder will trigger when there is a pharmacy near your location."
      //    case .customLocation:
      //      return "Custom Location"
    }
  }
}
