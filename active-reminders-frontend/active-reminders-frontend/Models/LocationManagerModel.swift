//
//  LocationManagerModel.swift
//  active-reminders-frontend
//
//  Created by Ronik on 24/02/2025.
//

import Foundation
import CoreLocation

final class LocationManagerModel: NSObject, CLLocationManagerDelegate {
  var locationManager = CLLocationManager()
  
  func checkLocationServices() {
    locationManager.delegate = self
    checkLocationAuthorization()
  }
  
  private func checkLocationAuthorization(){
    switch locationManager.authorizationStatus {
      case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
        print("This app needs always authorization for location")
        locationManager.requestAlwaysAuthorization()
      case .authorizedAlways:
        print("Location authorization granted")
      @unknown default:
        break
    }
  }
  
  func getLocation() -> Location? {
    if (self.locationManager.location == nil) {
      return nil
    }
    
    return Location(lat: self.locationManager.location!.coordinate.latitude, lon: self.locationManager.location!.coordinate.longitude)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
  }
}
