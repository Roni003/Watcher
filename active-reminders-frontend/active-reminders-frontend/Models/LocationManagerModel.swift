import SwiftUI
import Foundation
import CoreLocation

final class LocationManagerModel: NSObject, CLLocationManagerDelegate {
  var locationManager = CLLocationManager()
  private let minimumDistanceThreshold: CLLocationDistance = 25
  private var lastSentLocation: Location
  private var timer: Timer?
  private var updateInterval: TimeInterval = 180.0
  private var isBatterySaverModeEnabled = true
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
  
  public func setBatterySaverMode(_ enabled: Bool) {
    self.isBatterySaverModeEnabled = enabled
    print("Battery saver mode updated: \(enabled ? "enabled" : "disabled")")
  }
  
  override init() {
    self.lastSentLocation = Location(lat: 0, lon: 0)
    self.isUserInEngland = Locale.current.region?.identifier == "GB"

    super.init()
    locationManager.delegate = self
    checkLocationAuthorization()
    Task {
      await self.fetchInitialSettings()
    }
  }
  
  private func fetchInitialSettings() async {
    do {
      let currentUser = try await supabase.auth.session.user
      
      let data: User = try await supabase.from("users")
        .select()
        .eq("id", value: currentUser.id)
        .single()
        .execute()
        .value
      
      
      self.setUpdateInterval(TimeInterval(data.fetch_interval))
      self.setBatterySaverMode(data.battery_saver_mode)
    } catch {
      debugPrint(error)
    }
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
  
  /**
    * Returns If the location has changed significantly since the last request
   */
  private func hasLocationChangedSignificantly(from oldLocation: Location, to newLocation: Location) -> Bool {
    let oldCLLocation = CLLocation(latitude: oldLocation.lat, longitude: oldLocation.lon)
    let newCLLocation = CLLocation(latitude: newLocation.lat, longitude: newLocation.lon)
    
    let distance = oldCLLocation.distance(from: newCLLocation)
    
    print("Distance moved: \(distance) meters")
    
    return distance >= minimumDistanceThreshold
  }
  
  private func checkAndSendLocation() {
    
    if (self.isAppInForeground) {
      print("Skipping triggercheck since app is in foreground")
      return
    }
    
    guard let currentLocation = self.getLocation() else {
      print("Triggercheck check skipped - no location available")
      return
    }
    
    if !hasLocationChangedSignificantly(from: self.lastSentLocation, to: currentLocation) && self.isBatterySaverModeEnabled {
      print("Battery saver mode is on AND Location hasn't changed significantly, skipping triggercheck")
      return
    }
    
    Task {
      do {
        let triggeredReminders = try await sendTriggerCheck(
          triggerCheckRequest: TriggerCheckRequest(location: currentLocation)
        )
        
        self.lastSentLocation = currentLocation
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
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
  }
}
