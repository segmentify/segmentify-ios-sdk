import XCTest
@testable import Segmentify

final class CdpSubscribePayloadTests: XCTestCase {
    func testAllSubscribeChannelsSerializeExpectedFields() {
        let cases: [(CdpSubscribePayload, [String: Any])] = [
            (
                .iosPush(pushSubscriptionId: "push-token"),
                ["channel": "app_push", "pushSubscriptionId": "push-token"]
            ),
            (
                .email(email: "user@example.com", purpose: "marketing"),
                ["channel": "email", "email": "user@example.com", "purpose": "marketing"]
            ),
            (
                .whatsapp(phoneNumber: "+905551112233"),
                ["channel": "whatsapp", "phoneNumber": "+905551112233"]
            ),
            (
                .sms(phoneNumber: "+905551112233"),
                ["channel": "sms", "phoneNumber": "+905551112233"]
            ),
            (
                .call(phoneNumber: "+905551112233"),
                ["channel": "call", "phoneNumber": "+905551112233"]
            ),
        ]

        for (payload, expected) in cases {
            XCTAssertEqual(payload.toDictionary() as NSDictionary, expected as NSDictionary)
        }
    }

    func testSubscribePayloadsNeverUseLegacyApnsChannel() {
        let payloads: [CdpSubscribePayload] = [
            .iosPush(pushSubscriptionId: "token"),
            .email(email: "user@example.com", purpose: "marketing"),
            .whatsapp(phoneNumber: "123"),
            .sms(phoneNumber: "123"),
            .call(phoneNumber: "123"),
        ]

        for payload in payloads {
            XCTAssertNotEqual(payload.toDictionary()["channel"] as? String, "apns")
        }
    }

    func testSubscribePayloadsSerializeIntoUserSubscribeRequest() {
        let payload = CdpSubscribePayload.email(
            email: "user@example.com",
            purpose: "marketing"
        ).toDictionary()

        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.dataCenterUrl = "https://example.com"
        request.subdomain = "example.com"
        request.eventName = CdpEventName.userSubscribe
        request.userTraitsProperties = payload

        let dictionary = request.toDictionary()
        let properties = dictionary["properties"] as? [String: Any]

        XCTAssertEqual(dictionary["name"] as? String, "USER_SUBSCRIBE")
        XCTAssertEqual(properties?["channel"] as? String, "email")
        XCTAssertEqual(properties?["email"] as? String, "user@example.com")
        XCTAssertEqual(properties?["purpose"] as? String, "marketing")
    }
}
