import XCTest
@testable import Segmentify

final class CdpEventPayloadShapeTests: XCTestCase {
    func testIdentifyUserPayloadShape() {
        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.dataCenterUrl = "https://example.com"
        request.subdomain = "example.com"
        request.eventName = CdpEventName.userIdentify
        request.userTraitsProperties = [
            "email": "user@example.com",
            "emailConsent": CdpConsent.notSet.rawValue,
            "callConsent": CdpConsent.notSet.rawValue,
            "whatsappConsent": CdpConsent.notSet.rawValue,
            "smsConsent": CdpConsent.notSet.rawValue,
        ]

        let dictionary = request.toDictionary()
        let properties = dictionary["properties"] as? [String: Any]

        XCTAssertEqual(dictionary["name"] as? String, "USER_IDENTIFY")
        XCTAssertEqual(properties?["email"] as? String, "user@example.com")
        XCTAssertEqual(properties?["emailConsent"] as? String, "NOT_SET")
        XCTAssertNotNil(dictionary["apiKey"])
        XCTAssertEqual(dictionary["os"] as? String, "ios")
    }

    func testSubscribeUserIosPushPayloadShape() {
        let payload = CdpSubscribePayload.iosPush(pushSubscriptionId: "abc123").toDictionary()

        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.eventName = CdpEventName.userSubscribe
        request.userTraitsProperties = payload

        let dictionary = request.toDictionary()
        let properties = dictionary["properties"] as? [String: Any]

        XCTAssertEqual(dictionary["name"] as? String, "USER_SUBSCRIBE")
        XCTAssertEqual(properties?["channel"] as? String, "app_push")
        XCTAssertEqual(properties?["pushSubscriptionId"] as? String, "abc123")
    }

    func testSubscribeUserIosPushRequestBodyUsesIosPushChannel() throws {
        let payload = CdpSubscribePayload.iosPush(pushSubscriptionId: "abc123").toDictionary()

        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.dataCenterUrl = "https://example.com"
        request.subdomain = "example.com"
        request.eventName = CdpEventName.userSubscribe
        request.userTraitsProperties = payload

        let body = try JSONSerialization.data(withJSONObject: request.toDictionary(), options: [])
        let json = String(data: body, encoding: .utf8)!

        XCTAssertTrue(json.contains("\"channel\":\"app_push\"") || json.contains("\"channel\" : \"app_push\""))
        XCTAssertFalse(json.contains("\"channel\":\"apns\""))
        XCTAssertFalse(json.contains("\"channel\" : \"apns\""))
        XCTAssertFalse(json.contains("\"channel\":\"ios_push\""))
    }
}
