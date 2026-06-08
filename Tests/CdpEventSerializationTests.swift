import XCTest
@testable import Segmentify

final class CdpEventSerializationTests: XCTestCase {
    private let cdpEventNames = [
        "USER_TRAITS",
        "USER_IDENTIFY",
        "USER_REGISTER",
        "USER_LOGIN",
        "USER_LOGOUT",
        "USER_SUBSCRIBE",
        "USER_UNSUBSCRIBE",
    ]

    func testCdpEventsIncludeNameAndProperties() {
        for eventName in cdpEventNames {
            let request = SegmentifyRegisterRequest()
            request.apiKey = "test-api-key"
            request.dataCenterUrl = "https://example.com"
            request.subdomain = "example.com"
            request.eventName = eventName
            request.userTraitsProperties = ["email": "user@example.com"]

            let dictionary = request.toDictionary()

            XCTAssertEqual(dictionary["name"] as? String, eventName)
            XCTAssertEqual(
                (dictionary["properties"] as? [String: Any])?["email"] as? String,
                "user@example.com",
                "Failed for event \(eventName)"
            )
        }
    }

    func testNonCdpEventDoesNotIncludeProperties() {
        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.dataCenterUrl = "https://example.com"
        request.subdomain = "example.com"
        request.eventName = "PAGE_VIEW"
        request.userTraitsProperties = ["email": "user@example.com"]
        request.category = "home"

        let dictionary = request.toDictionary()

        XCTAssertEqual(dictionary["name"] as? String, "PAGE_VIEW")
        XCTAssertNil(dictionary["properties"])
    }

    func testClearVariablesResetsUserTraitsProperties() {
        let request = SegmentifyRegisterRequest()
        request.userTraitsProperties = ["email": "user@example.com"]

        request.clearVariables()

        XCTAssertNil(request.userTraitsProperties)
    }

    func testPageViewAfterSubscribePayloadDoesNotIncludeProperties() {
        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.dataCenterUrl = "https://example.com"
        request.subdomain = "example.com"
        request.eventName = CdpEventName.userSubscribe
        request.userTraitsProperties = CdpSubscribePayload.iosPush(
            pushSubscriptionId: "device-token"
        ).toDictionary()

        request.eventName = "PAGE_VIEW"
        request.category = "Home Page"
        if let eventName = request.eventName,
           !CdpEventName.eventsWithProperties.contains(eventName) {
            request.userTraitsProperties = nil
        }

        let dictionary = request.toDictionary()

        XCTAssertEqual(dictionary["name"] as? String, "PAGE_VIEW")
        XCTAssertNil(dictionary["properties"])
        XCTAssertEqual(dictionary["category"] as? String, "Home Page")
    }
}
