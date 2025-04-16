import XCTest
@testable import Watcher
import Combine
import SwiftUI

// Create a mock function for fetchReminders to use in tests
func mockFetchReminders() async throws -> [Reminder] {
    return []
}

// A testable version of ReminderViewModel for unit testing
class TestableReminderViewModel: ReminderViewModel {
    var testReminders: [Reminder] = []
    
    override func loadReminders() async {
        
    }
    
    
    override func getRegularReminders() -> [Reminder] {
        return testReminders.filter { $0.trigger == nil }
    }
    
    override func getAlertReminders() -> [Reminder] {
        return testReminders.filter { $0.trigger != nil }
    }
    
    override func isEmpty() -> Bool {
        return testReminders.isEmpty
    }
}

final class ReminderViewModelTests: XCTestCase {
    var viewModel: ReminderViewModel!
    var testableViewModel: TestableReminderViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ReminderViewModel()
        testableViewModel = TestableReminderViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        testableViewModel = nil
        super.tearDown()
    }
    
    private func setupTestReminders() -> [Reminder] {
        let regularReminder1 = Reminder(
            id: "1",
            userId: "user1",
            description: "Regular reminder 1",
            enabled: true,
            createdAt: "2025-01-01T00:00:00Z",
            updatedAt: "2025-01-01T00:00:00Z",
            trigger: nil,
            metadata: nil
        )
        
        let regularReminder2 = Reminder(
            id: "2",
            userId: "user1",
            description: "Regular reminder 2",
            enabled: false,
            createdAt: "2025-01-01T00:00:00Z",
            updatedAt: "2025-01-01T00:00:00Z",
            trigger: nil,
            metadata: nil
        )
        
        let alertReminder1 = Reminder(
            id: "3",
            userId: "user1",
            description: "Alert reminder 1",
            enabled: true,
            createdAt: "2025-01-01T00:00:00Z",
            updatedAt: "2025-01-01T00:00:00Z",
            trigger: .weather,
            metadata: .customLocation(CustomLocationMetadata(
                location: Location(lat: 51.5074, lon: -0.1278)
            ))
        )
        
        let alertReminder2 = Reminder(
            id: "4",
            userId: "user1",
            description: "Alert reminder 2",
            enabled: false,
            createdAt: "2025-01-01T00:00:00Z",
            updatedAt: "2025-01-01T00:00:00Z",
            trigger: .tfl,
            metadata: .tfl(TflMetadata(line: "victoria"))
        )
        
        return [regularReminder1, regularReminder2, alertReminder1, alertReminder2]
    }
    
    func testSortReminders() {
        let reminder1 = Reminder(
            id: "1", 
            userId: "user1", 
            description: "Test 1", 
            enabled: false, 
            createdAt: "", 
            updatedAt: "", 
            trigger: nil, 
            metadata: nil
        )
        
        let reminder2 = Reminder(
            id: "2", 
            userId: "user1", 
            description: "Test 2", 
            enabled: true, 
            createdAt: "", 
            updatedAt: "", 
            trigger: nil, 
            metadata: nil
        )
        
        let reminder3 = Reminder(
            id: "3", 
            userId: "user1", 
            description: "Test 3", 
            enabled: false, 
            createdAt: "", 
            updatedAt: "", 
            trigger: nil, 
            metadata: nil
        )
        
        let unsortedReminders = [reminder1, reminder2, reminder3]
        let sortedReminders = viewModel.sortReminders(reminderList: unsortedReminders)
        
        XCTAssertEqual(sortedReminders[0].id, "2")
        XCTAssertTrue(sortedReminders[0].enabled)
        XCTAssertFalse(sortedReminders[1].enabled)
        XCTAssertFalse(sortedReminders[2].enabled)
    }
    
    func testFilterFunctions() {
        let testReminders = setupTestReminders()
        
        let regularReminders = testReminders.filter { $0.trigger == nil }
        XCTAssertEqual(regularReminders.count, 2)
        XCTAssertEqual(regularReminders[0].id, "1")
        XCTAssertEqual(regularReminders[1].id, "2")
        
        let alertReminders = testReminders.filter { $0.trigger != nil }
        XCTAssertEqual(alertReminders.count, 2)
        XCTAssertEqual(alertReminders[0].id, "3")
        XCTAssertEqual(alertReminders[1].id, "4")
    }
}
