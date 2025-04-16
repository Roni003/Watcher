import XCTest
@testable import Watcher

final class TriggerTypesTests: XCTestCase {
    
    func testTriggerTypeIconName() {
        // Test that each trigger type returns the expected icon name
        XCTAssertEqual(TriggerType.weather.iconName, "cloud.rain.fill")
        XCTAssertEqual(TriggerType.traffic.iconName, "car.fill")
        XCTAssertEqual(TriggerType.tfl.iconName, "train.side.front.car")
        XCTAssertEqual(TriggerType.groceryStore.iconName, "storefront.fill")
        XCTAssertEqual(TriggerType.pharmacy.iconName, "pill.fill")
    }
    
    func testTriggerTypeDisplayText() {
        // Test that each trigger type returns the expected display text
        XCTAssertEqual(TriggerType.weather.displayText, "Harsh Weather Conditions")
        XCTAssertEqual(TriggerType.traffic.displayText, "Heavy Traffic In Area")
        XCTAssertEqual(TriggerType.tfl.displayText, "TFL Underground Delays")
        XCTAssertEqual(TriggerType.groceryStore.displayText, "Grocery Stores Nearby")
        XCTAssertEqual(TriggerType.pharmacy.displayText, "Pharmacies Nearby")
    }
    
    func testTriggerTypeDescriptionText() {
        // Test that each trigger type returns the expected description text
        XCTAssertEqual(TriggerType.weather.descriptionText, "This alert will trigger when there is rain, snow, storms in your area.")
        XCTAssertEqual(TriggerType.traffic.descriptionText, "This alert will trigger when there is heavy traffic in your area.")
        XCTAssertEqual(TriggerType.tfl.descriptionText, "This alert will trigger when there are delays or distruptions on the line you choose.")
        XCTAssertEqual(TriggerType.groceryStore.descriptionText, "This alert will trigger when there is a grocery store near your location.")
        XCTAssertEqual(TriggerType.pharmacy.descriptionText, "This alert will trigger when there is a pharmacy near your location.")
    }
    
    func testTriggerTypeEncodingDecoding() throws {
        let types: [TriggerType] = [.weather, .traffic, .tfl, .groceryStore, .pharmacy]
        
        for type in types {
            let encoder = JSONEncoder()
            let data = try encoder.encode(type)
            
            let encodedString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\"", with: "")
            XCTAssertEqual(encodedString, type.rawValue)
            
            let decoder = JSONDecoder()
            let decodedType = try decoder.decode(TriggerType.self, from: data)
            XCTAssertEqual(decodedType, type)
        }
    }
    
    func testTriggerTypeNotificationSound() {
        XCTAssertNotNil(TriggerType.weather.notificationSound)
        XCTAssertNotNil(TriggerType.traffic.notificationSound)
        XCTAssertNotNil(TriggerType.tfl.notificationSound)
        XCTAssertNotNil(TriggerType.groceryStore.notificationSound)
        XCTAssertNotNil(TriggerType.pharmacy.notificationSound)
    }
}
