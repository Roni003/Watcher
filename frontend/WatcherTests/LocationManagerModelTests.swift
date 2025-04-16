import XCTest
import CoreLocation
@testable import Watcher

final class LocationManagerModelTests: XCTestCase {
    
    var locationManager: LocationManagerModel!
    var mockCLLocationManager: MockCLLocationManager!
    
    override func setUp() {
        super.setUp()
        mockCLLocationManager = MockCLLocationManager()
        locationManager = LocationManagerModel()
    }
    
    override func tearDown() {
        locationManager = nil
        mockCLLocationManager = nil
        super.tearDown()
    }
    
    func testLocationManagerInitialization() {
        XCTAssertNotNil(locationManager)
        XCTAssertNotNil(locationManager.locationManager)
    }
}

class MockCLLocationManager: CLLocationManager {
    var startUpdatingLocationCalled = false
    var stopUpdatingLocationCalled = false
    var requestAlwaysAuthorizationCalled = false
    
    override func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }
    
    override func stopUpdatingLocation() {
        stopUpdatingLocationCalled = true
    }
    
    override func requestAlwaysAuthorization() {
        requestAlwaysAuthorizationCalled = true
    }
}
