import XCTest
@testable import Watcher

final class RequestsResponsesTests: XCTestCase {
    
    func testTriggerCheckRequest() throws {
        let location = Location(lat: 51.5074, lon: -0.1278)
        let request = TriggerCheckRequest(location: location)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        // Verify the encoded JSON
        if let locationJson = jsonObject["location"] as? [String: Any] {
            XCTAssertEqual(locationJson["lat"] as? Double, 51.5074)
            XCTAssertEqual(locationJson["lon"] as? Double, -0.1278)
        } else {
            XCTFail("Expected location object in JSON")
        }
        
        let decoder = JSONDecoder()
        let decodedRequest = try decoder.decode(TriggerCheckRequest.self, from: data)
        
        XCTAssertEqual(decodedRequest.location.lat, 51.5074)
        XCTAssertEqual(decodedRequest.location.lon, -0.1278)
    }
    
    func testTriggerCheckResponse() throws {
        let response = TriggerCheckRespone(reminders: [
            ReminderMessagePair(
                reminder: Reminder(
                    id: "1",
                    userId: "user123",
                    description: "Weather reminder",
                    enabled: true,
                    createdAt: "2025-01-01T00:00:00Z",
                    updatedAt: "2025-01-02T00:00:00Z",
                    trigger: .weather,
                    metadata: .customLocation(CustomLocationMetadata(location: Location(lat: 51.5074, lon: -0.1278)))
                ),
                message: "Weather alert activated"
            ),
            ReminderMessagePair(
                reminder: Reminder(
                    id: "2",
                    userId: "user123",
                    description: "Traffic reminder",
                    enabled: true,
                    createdAt: "2025-01-01T00:00:00Z",
                    updatedAt: "2025-01-02T00:00:00Z",
                    trigger: .traffic,
                    metadata: nil
                ),
                message: "Traffic alert activated"
            )
        ])
        
  
        let encoder = JSONEncoder()
        let data = try encoder.encode(response)
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(TriggerCheckRespone.self, from: data)
        
        XCTAssertEqual(decodedResponse.reminders.count, 2)
        XCTAssertEqual(decodedResponse.reminders[0].reminder.id, "1")
        XCTAssertEqual(decodedResponse.reminders[0].reminder.description, "Weather reminder")
        XCTAssertEqual(decodedResponse.reminders[0].message, "Weather alert activated")
        XCTAssertEqual(decodedResponse.reminders[1].reminder.id, "2")
        XCTAssertEqual(decodedResponse.reminders[1].reminder.description, "Traffic reminder")
        XCTAssertEqual(decodedResponse.reminders[1].message, "Traffic alert activated")
    }
    
    func testCreateReminderRequest() throws {
        let testCases = [
            (
                "Basic reminder without trigger",
                CreateReminderRequest(description: "Test reminder", triggerType: nil, trainLine: nil)
            ),
            (
                "Weather trigger reminder",
                CreateReminderRequest(description: "Weather alert", triggerType: .weather, trainLine: nil)
            ),
            (
                "TFL trigger with train line",
                CreateReminderRequest(description: "TFL alert", triggerType: .tfl, trainLine: TrainLine.victoria)
            )
        ]
        
        for (testName, request) in testCases {
            let encoder = JSONEncoder()
            let data = try encoder.encode(request)
            let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            XCTAssertEqual(jsonObject["description"] as? String, request.description, testName)
            
            if request.trigger != nil {
                XCTAssertEqual(jsonObject["trigger"] as? String, request.trigger, testName)
            } else {
                XCTAssertNil(jsonObject["trigger"], testName)
            }
            
            if let metadata = request.metadata, let jsonMetadata = jsonObject["metadata"] as? [String: String] {
                if let line = metadata["line"] {
                    XCTAssertEqual(jsonMetadata["line"], line, testName)
                }
            } else if request.metadata == nil {
                let jsonMetadata = jsonObject["metadata"]
                let isNilOrEmpty = jsonMetadata == nil || 
                                  (jsonMetadata as? [String: String])?.isEmpty == true
                XCTAssertTrue(isNilOrEmpty, testName)
            }
            
            let decoder = JSONDecoder()
            let decodedRequest = try decoder.decode(CreateReminderRequest.self, from: data)
            
            XCTAssertEqual(decodedRequest.description, request.description, testName)
            XCTAssertEqual(decodedRequest.trigger, request.trigger, testName)
            
            if let originalMetadata = request.metadata, let decodedMetadata = decodedRequest.metadata {
                for (key, value) in originalMetadata {
                    XCTAssertEqual(decodedMetadata[key], value, "\(testName) - metadata field: \(key)")
                }
            } else {
                XCTAssertEqual(decodedRequest.metadata, request.metadata, testName)
            }
        }
    }
    
    func testToggleReminderRequest() throws {
        let testCases = [
            ("Enable reminder", ToggleReminderRequest(enabled: true)),
            ("Disable reminder", ToggleReminderRequest(enabled: false))
        ]
        
        for (testName, request) in testCases {
            let encoder = JSONEncoder()
            let data = try encoder.encode(request)
            let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            XCTAssertEqual(jsonObject["enabled"] as? Bool, request.enabled, testName)
            
            let decoder = JSONDecoder()
            let decodedRequest = try decoder.decode(ToggleReminderRequest.self, from: data)
            
            XCTAssertEqual(decodedRequest.enabled, request.enabled, testName)
        }
    }
}
