//
//  TrainLine.swift
//  active-reminders-frontend
//
//  Created by Ronik on 21/02/2025.
//

import Foundation
import SwiftUI

enum TrainLine: String, CaseIterable, Codable {
  case bakerloo = "Bakerloo"
  case central = "Central"
  case circle = "Circle"
  case district = "District"
  case elizabeth = "Elizabeth"
  case hammersmith = "hammersmith-city"
  case jubilee = "Jubilee"
  case metropolitan = "Metropolitan"
  case northern = "Northern"
  case piccadilly = "Piccadilly"
  case victoria = "Victoria"
  case waterloo = "waterloo-city"
  
  var displayName: String {
    switch self {
    case .bakerloo:
      return "Bakerloo"
    case .central:
      return "Central"
    case .circle:
      return "Circle"
    case .district:
      return "District"
    case .elizabeth:
      return "Elizabeth"
    case .hammersmith:
      return "Hammersmith & City"
    case .jubilee:
      return "Jubilee"
    case .metropolitan:
      return "Metropolitan"
    case .northern:
      return "Northern"
    case .piccadilly:
      return "Piccadilly"
    case .victoria:
      return "Victoria"
    case .waterloo:
      return "Waterloo & City"
    }
  }
  
  var color: Color {
    switch self {
    case .bakerloo: return Color(UIColor(hexCode: "#B36305", alpha: 1))
    case .central: return Color(UIColor(hexCode: "#E32017", alpha: 1))
    case .circle: return Color(UIColor(hexCode: "#FFD300", alpha: 1))
    case .district: return Color(UIColor(hexCode: "#00782A", alpha: 1))
    case .elizabeth: return Color(UIColor(hexCode: "#6950a1", alpha: 1))
    case .hammersmith: return Color(UIColor(hexCode: "#F3A9BB", alpha: 1))
    case .jubilee: return Color(UIColor(hexCode: "#A0A5A9", alpha: 1))
    case .metropolitan: return Color(UIColor(hexCode: "#9B0056", alpha: 1))
    case .northern: return Color.black
    case .piccadilly: return Color(UIColor(hexCode: "#003688", alpha: 1))
    case .victoria: return Color(UIColor(hexCode: "#0098D4", alpha: 1))
    case .waterloo: return Color(UIColor(hexCode: "#95CDBA", alpha: 1))
    }
  }
}
