import XCTest
@testable import Watcher

final class UserModelTests: XCTestCase {
    
    func testDecodeUser() throws {
        let json = """
        {
            "id": "user123",
            "radius": 500,
            "fetch_interval": 60,
            "blacklist": {},
            "created_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-02T00:00:00Z",
            "battery_saver_mode": true
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: json)
        
        XCTAssertEqual(user.id, "user123")
        XCTAssertEqual(user.radius, 500)
        XCTAssertEqual(user.fetch_interval, 60)
        XCTAssertEqual(user.created_at, "2025-01-01T00:00:00Z")
        XCTAssertEqual(user.updated_at, "2025-01-02T00:00:00Z")
        XCTAssertTrue(user.battery_saver_mode)
    }
    
    func testDecodeUserWithoutOptionalFields() throws {
        let json = """
        {
            "id": "user123",
            "radius": 500,
            "fetch_interval": 60,
            "created_at": "2025-01-01T00:00:00Z",
            "battery_saver_mode": false
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: json)
        
        XCTAssertEqual(user.id, "user123")
        XCTAssertEqual(user.radius, 500)
        XCTAssertEqual(user.fetch_interval, 60)
        XCTAssertEqual(user.created_at, "2025-01-01T00:00:00Z")
        XCTAssertNil(user.updated_at)
        XCTAssertFalse(user.battery_saver_mode)
        XCTAssertNil(user.blacklist)
    }
    
    func testEncodeUser() throws {
        let user = User(
            id: "user123",
            radius: 500,
            fetch_interval: 60,
            blacklist: nil,
            created_at: "2025-01-01T00:00:00Z",
            updated_at: "2025-01-02T00:00:00Z",
            battery_saver_mode: true
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        XCTAssertEqual(jsonObject["id"] as? String, "user123")
        XCTAssertEqual(jsonObject["radius"] as? Int, 500)
        XCTAssertEqual(jsonObject["fetch_interval"] as? Int, 60)
        XCTAssertEqual(jsonObject["created_at"] as? String, "2025-01-01T00:00:00Z")
        XCTAssertEqual(jsonObject["updated_at"] as? String, "2025-01-02T00:00:00Z")
        XCTAssertEqual(jsonObject["battery_saver_mode"] as? Bool, true)
    }
    
    func testEncodeUserWithoutOptionalFields() throws {
        let user = User(
            id: "user123",
            radius: 500,
            fetch_interval: 60,
            blacklist: nil,
            created_at: "2025-01-01T00:00:00Z",
            updated_at: nil,
            battery_saver_mode: false
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        XCTAssertEqual(jsonObject["id"] as? String, "user123")
        XCTAssertEqual(jsonObject["radius"] as? Int, 500)
        XCTAssertEqual(jsonObject["fetch_interval"] as? Int, 60)
        XCTAssertEqual(jsonObject["created_at"] as? String, "2025-01-01T00:00:00Z")
        XCTAssertNil(jsonObject["updated_at"])
        XCTAssertEqual(jsonObject["battery_saver_mode"] as? Bool, false)
        XCTAssertNil(jsonObject["blacklist"])
    }
}
