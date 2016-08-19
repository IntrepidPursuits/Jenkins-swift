import XCTest
@testable import Jenkins

class JenkinsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Jenkins().text, "Hello, World!")
    }


    static var allTests : [(String, (JenkinsTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
