import XCTest
@testable import Watcher

final class TrainLineTests: XCTestCase {
    
    func testTrainLineRawValues() {
        // Test that each train line has the expected raw value
        XCTAssertEqual(TrainLine.bakerloo.rawValue, "Bakerloo")
        XCTAssertEqual(TrainLine.central.rawValue, "Central")
        XCTAssertEqual(TrainLine.circle.rawValue, "Circle")
        XCTAssertEqual(TrainLine.district.rawValue, "District")
        XCTAssertEqual(TrainLine.elizabeth.rawValue, "Elizabeth")
        XCTAssertEqual(TrainLine.hammersmith.rawValue, "hammersmith-city")
        XCTAssertEqual(TrainLine.jubilee.rawValue, "Jubilee")
        XCTAssertEqual(TrainLine.metropolitan.rawValue, "Metropolitan")
        XCTAssertEqual(TrainLine.northern.rawValue, "Northern")
        XCTAssertEqual(TrainLine.piccadilly.rawValue, "Piccadilly")
        XCTAssertEqual(TrainLine.victoria.rawValue, "Victoria")
        XCTAssertEqual(TrainLine.waterloo.rawValue, "waterloo-city")
    }
    
    func testTrainLineDisplayNames() {
        // Test that each train line has the expected display name
        XCTAssertEqual(TrainLine.bakerloo.displayName, "Bakerloo")
        XCTAssertEqual(TrainLine.central.displayName, "Central")
        XCTAssertEqual(TrainLine.hammersmith.displayName, "Hammersmith & City")
        XCTAssertEqual(TrainLine.waterloo.displayName, "Waterloo & City")
    }
    
    func testTrainLineEncodingDecoding() throws {
        // Test that TrainLine can be encoded and decoded correctly
        for trainLine in TrainLine.allCases {
            let encoder = JSONEncoder()
            let data = try encoder.encode(trainLine)
            
            // Verify encoded value is the raw value
            let encodedString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\"", with: "")
            XCTAssertEqual(encodedString, trainLine.rawValue)
            
            // Verify decoding works
            let decoder = JSONDecoder()
            let decodedTrainLine = try decoder.decode(TrainLine.self, from: data)
            XCTAssertEqual(decodedTrainLine, trainLine)
        }
    }
    
    func testTrainLineColorNotNil() {
        // Test that each train line has a non-nil color
        for trainLine in TrainLine.allCases {
            XCTAssertNotNil(trainLine.color)
        }
    }
    
    func testTrainLineCaseIterable() {
        // Test that CaseIterable works and contains all cases
        let allTrainLines = TrainLine.allCases
        XCTAssertEqual(allTrainLines.count, 12)
        XCTAssertTrue(allTrainLines.contains(.bakerloo))
        XCTAssertTrue(allTrainLines.contains(.central))
        XCTAssertTrue(allTrainLines.contains(.circle))
        XCTAssertTrue(allTrainLines.contains(.district))
        XCTAssertTrue(allTrainLines.contains(.elizabeth))
        XCTAssertTrue(allTrainLines.contains(.hammersmith))
        XCTAssertTrue(allTrainLines.contains(.jubilee))
        XCTAssertTrue(allTrainLines.contains(.metropolitan))
        XCTAssertTrue(allTrainLines.contains(.northern))
        XCTAssertTrue(allTrainLines.contains(.piccadilly))
        XCTAssertTrue(allTrainLines.contains(.victoria))
        XCTAssertTrue(allTrainLines.contains(.waterloo))
    }
}