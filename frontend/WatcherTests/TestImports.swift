import XCTest
import SwiftUI
import Combine
@testable import Watcher

extension Mirror {
    func extract<T>(varName: String) -> T? {
        self.children.first(where: { $0.label == varName })?.value as? T
    }
}

extension XCTestCase {
    func expectAsync<T>(
        description: String = "Async expectation",
        timeout: TimeInterval = 2.0,
        asyncBlock: @escaping () async throws -> T
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            let expectation = expectation(description: description)
            
            Task {
                do {
                    let result = try await asyncBlock()
                    expectation.fulfill()
                    continuation.resume(returning: result)
                } catch {
                    expectation.fulfill()
                    continuation.resume(throwing: error)
                }
            }
            
            wait(for: [expectation], timeout: timeout)
        }
    }
}


@available(iOS 15.0, *)
struct ViewInspector<Content: View>: View {
    let content: Content
    let inspection: (Content) -> Void
    
    var body: some View {
        content
            .onAppear { inspection(content) }
    }
    
    init(content: Content, inspection: @escaping (Content) -> Void) {
        self.content = content
        self.inspection = inspection
    }
}

@available(iOS 15.0, *)
extension View {
    func inspect(_ inspection: @escaping (Self) -> Void) -> some View {
        ViewInspector(content: self, inspection: inspection)
    }
}
