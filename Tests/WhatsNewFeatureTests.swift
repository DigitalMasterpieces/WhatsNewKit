import XCTest
@testable import WhatsNewKit

// MARK: - WhatsNewFeatureTests

/// The WhatsNewFeatureTests
final class WhatsNewFeatureTests: WhatsNewKitTestCase {

    /// Test that a Feature is not prominent by default
    func testIsProminentDefaultsToFalse() {
        let feature = WhatsNew.Feature(
            image: .init(systemName: "star"),
            title: "Title",
            subtitle: "Subtitle"
        )
        XCTAssertFalse(feature.isProminent)
    }

    /// Test that the isProminent flag is stored
    func testIsProminentIsStored() {
        let feature = WhatsNew.Feature(
            image: .init(systemName: "star"),
            title: "Title",
            subtitle: "Subtitle",
            isProminent: true
        )
        XCTAssertTrue(feature.isProminent)
    }

}
