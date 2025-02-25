import Foundation
import CoreLocation

final class LocationManagerModel: NSObject, CLLocationManagerDelegate {
  var locationManager = CLLocationManager()
  private var timer: Timer?
  private let updateInterval: TimeInterval = 30.0 // 30 seconds
  
  override init() {
    super.init()
    locationManager.delegate = self
    checkLocationAuthorization()
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
    
    if (location != nil) {
      Task {
        do {
          let triggeredReminders = try await sendTriggerCheck(
            triggerCheckRequest: TriggerCheckRequest(location: location!)
          )
          
          let reminders = triggeredReminders.reminders
          
          if !reminders.isEmpty {
            DispatchQueue.main.async {
              triggerReminders(reminders: reminders)
            }
          }
          
          print("Location check completed with \(reminders.count) triggered reminders")
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
