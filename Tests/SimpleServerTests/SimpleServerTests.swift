import XCTest
@testable import SimpleServer

final class SimpleServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SimpleServer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
