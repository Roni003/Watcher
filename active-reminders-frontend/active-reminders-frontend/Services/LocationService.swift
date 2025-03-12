import SwiftUI
import Foundation
import CoreLocation

final class LocationManagerModel: NSObject, CLLocationManagerDelegate {
  var locationManager = CLLocationManager()
  private var timer: Timer?
  private var updateInterval: TimeInterval = 180.0
  private var isAppInForeground: Bool = true
  public var isUserInEngland: Bool = false
  
  public func setUpdateInterval(_ interval: TimeInterval) {
    self.updateInterval = interval
    print("Triggercheck fetch interval set to: \(interval)")
    self.updateTimerInterval(to: interval)
  }
  
  public func updateAppState(isInForeground: Bool) {
    self.isAppInForeground = isInForeground
    print("App state updated: \(isInForeground ? "foreground" : "background")")
  }
  
  
  override init() {
    super.init()
    locationManager.delegate = self
    checkLocationAuthorization()
    
    self.isUserInEngland = Locale.current.region?.identifier == "GB"
  }
  
  deinit {
    stopLocationUpdates()
  }
  
  private func checkLocationAuthorization() {
    switch locationManager.authorizationStatus {
    case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
      print("This app needs always authorization for location")
      locationManager.requestAlwaysAuthorization()
    case .authorizedAlways:
      print("Location authorization granted")
      startLocationUpdates()
    @unknown default:
      break
    }
  }
  
  public func getLocation() -> Location? {
    if (self.locationManager.location == nil) {
      return nil
    }
    
    return Location(lat: self.locationManager.location!.coordinate.latitude,
                    lon: self.locationManager.location!.coordinate.longitude)
  }
  

  func startLocationUpdates() {
    locationManager.startUpdatingLocation()
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    
    stopTimer()
    
    timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
      self?.checkAndSendLocation()
    }
    
    checkAndSendLocation()
    
    print("Started location updates with \(updateInterval) second interval")
  }
  
  func updateTimerInterval(to newInterval: TimeInterval) {
    stopTimer()
    
    timer = Timer.scheduledTimer(withTimeInterval: newInterval, repeats: true) { [weak self] _ in
      self?.checkAndSendLocation()
    }
    
    print("Timer updated to new interval: \(newInterval) seconds")
  }
  
  func stopLocationUpdates() {
    locationManager.stopUpdatingLocation()
    stopTimer()
    print("Stopped location updates")
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  private func checkAndSendLocation() {
    let location = self.getLocation()
    if (self.isAppInForeground) {
      print("Skipping triggercheck since app is in foreground")
      return
    }
    
    if (location != nil) {
      Task {
        do {
          let triggeredReminders = try await sendTriggerCheck(
            triggerCheckRequest: TriggerCheckRequest(location: location!)
          )
          
          let reminderMessagePairs: [ReminderMessagePair] = triggeredReminders.reminders
          
          if !reminderMessagePairs.isEmpty {
            DispatchQueue.main.async {
              triggerReminders(reminderMessagePairs: reminderMessagePairs)
            }
          }
          
          print("Location check completed with \(reminderMessagePairs.count) triggered reminders")
        } catch {
          print("Error checking location triggers: \(error.localizedDescription)")
        }
      }
    } else {
      print("Location check skipped - no location available")
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
  }
}
