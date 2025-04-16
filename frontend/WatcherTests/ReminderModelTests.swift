import XCTest
@testable import Watcher

final class ReminderModelTests: XCTestCase {
    
    func testDecodeCustomLocationReminder() throws {
        let json = """
        {
            "id": "123",
            "user_id": "user123",
            "description": "Test reminder",
            "enabled": true,
            "created_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-02T00:00:00Z",
            "trigger": "weather",
            "metadata": {
                "location": {
                    "lat": 51.5074,
                    "lon": -0.1278
                }
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let reminder = try decoder.decode(Reminder.self, from: json)
        
        XCTAssertEqual(reminder.id, "123")
        XCTAssertEqual(reminder.userId, "user123")
        XCTAssertEqual(reminder.description, "Test reminder")
        XCTAssertEqual(reminder.enabled, true)
        XCTAssertEqual(reminder.createdAt, "2025-01-01T00:00:00Z")
        XCTAssertEqual(reminder.updatedAt, "2025-01-02T00:00:00Z")
        XCTAssertEqual(reminder.trigger, .weather)
        
        if case let .customLocation(metadata) = reminder.metadata {
            XCTAssertEqual(metadata.location.lat, 51.5074)
            XCTAssertEqual(metadata.location.lon, -0.1278)
        } else {
            XCTFail("Expected customLocation metadata")
        }
    }
    
    func testDecodeTflReminder() throws {
        let json = """
        {
            "id": "456",
            "user_id": "user123",
            "description": "TFL reminder",
            "enabled": true,
            "created_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-02T00:00:00Z",
            "trigger": "tfl",
            "metadata": {
                "line": "victoria"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let reminder = try decoder.decode(Reminder.self, from: json)
        
        XCTAssertEqual(reminder.id, "456")
        XCTAssertEqual(reminder.userId, "user123")
        XCTAssertEqual(reminder.description, "TFL reminder")
        XCTAssertEqual(reminder.enabled, true)
        XCTAssertEqual(reminder.createdAt, "2025-01-01T00:00:00Z")
        XCTAssertEqual(reminder.updatedAt, "2025-01-02T00:00:00Z")
        XCTAssertEqual(reminder.trigger, .tfl)
        
        if case let .tfl(metadata) = reminder.metadata {
            XCTAssertEqual(metadata.line, "victoria")
        } else {
            XCTFail("Expected tfl metadata")
        }
    }
    
    func testEncodeCustomLocationReminder() throws {
        let reminder = Reminder(
            id: "123",
            userId: "user123",
            description: "Test reminder",
            enabled: true,
            createdAt: "2025-01-01T00:00:00Z",
            updatedAt: "2025-01-02T00:00:00Z",
            trigger: .weather,
            metadata: .customLocation(CustomLocationMetadata(
                location: Location(lat: 51.5074, lon: -0.1278)
            ))
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(reminder)
        let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        XCTAssertEqual(jsonObject["id"] as? String, "123")
        XCTAssertEqual(jsonObject["user_id"] as? String, "user123")
        XCTAssertEqual(jsonObject["description"] as? String, "Test reminder")
        XCTAssertEqual(jsonObject["enabled"] as? Bool, true)
        XCTAssertEqual(jsonObject["created_at"] as? String, "2025-01-01T00:00:00Z")
        XCTAssertEqual(jsonObject["updated_at"] as? String, "2025-01-02T00:00:00Z")
        XCTAssertEqual(jsonObject["trigger"] as? String, "weather")
        
        if let metadata = jsonObject["metadata"] as? [String: Any], 
           let location = metadata["location"] as? [String: Any] {
            XCTAssertEqual(location["lat"] as? Double, 51.5074)
            XCTAssertEqual(location["lon"] as? Double, -0.1278)
        } else {
            XCTFail("Expected location metadata")
        }
    }
    
    func testEncodeTflReminder() throws {
        let reminder = Reminder(
            id: "456",
            userId: "user123",
            description: "TFL reminder",
            enabled: true,
            createdAt: "2025-01-01T00:00:00Z",
            updatedAt: "2025-01-02T00:00:00Z",
            trigger: .tfl,
            metadata: .tfl(TflMetadata(line: "victoria"))
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(reminder)
        let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        XCTAssertEqual(jsonObject["id"] as? String, "456")
        XCTAssertEqual(jsonObject["user_id"] as? String, "user123")
        XCTAssertEqual(jsonObject["description"] as? String, "TFL reminder")
        XCTAssertEqual(jsonObject["enabled"] as? Bool, true)
        XCTAssertEqual(jsonObject["created_at"] as? String, "2025-01-01T00:00:00Z")
        XCTAssertEqual(jsonObject["updated_at"] as? String, "2025-01-02T00:00:00Z")
        XCTAssertEqual(jsonObject["trigger"] as? String, "tfl")
        
        if let metadata = jsonObject["metadata"] as? [String: Any] {
            XCTAssertEqual(metadata["line"] as? String, "victoria")
        } else {
            XCTFail("Expected tfl metadata")
        }
    }
    
    func testDecodeInvalidMetadata() {
        let json = """
        {
            "id": "123",
            "user_id": "user123",
            "description": "Test reminder",
            "enabled": true,
            "created_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-02T00:00:00Z",
            "metadata": {
                "invalid_key": "invalid_value"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Reminder.self, from: json)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
