import XCTest

@testable import LARGPSInterop

final class GPSObservationTests: XCTestCase {
    func testBridgesPODStructAndVector() {
        let obs = demoGPSObservations()
        XCTAssertEqual(obs.count, 2)

        XCTAssertEqual(obs[0].timestamp, 1000)
        XCTAssertEqual(obs[0].relative, SIMD3(1, 2, 3))
        XCTAssertEqual(obs[0].global, SIMD3(10, 20, 30))
        XCTAssertEqual(obs[0].accuracy, SIMD3(0.1, 0.1, 0.2))

        XCTAssertEqual(obs[1].timestamp, 2000)
        XCTAssertEqual(obs[1].relative, SIMD3(4, 5, 6))
        XCTAssertEqual(obs[1].global, SIMD3(40, 50, 60))
    }
}
