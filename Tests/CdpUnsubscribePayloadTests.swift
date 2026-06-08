import XCTest
@testable import Segmentify

final class CdpUnsubscribePayloadTests: XCTestCase {
    func testAllUnsubscribeChannelsSerializeExpectedFields() {
        let cases: [(CdpUnsubscribePayload, [String: Any])] = [
            (
                CdpUnsubscribePayload(channel: .iosPush),
                ["channel": "app_push"]
            ),
            (
                CdpUnsubscribePayload(channel: .email, email: "user@example.com"),
                ["channel": "email", "email": "user@example.com"]
            ),
            (
                CdpUnsubscribePayload(channel: .whatsapp, phoneNumber: "+905551112233"),
                ["channel": "whatsapp", "phoneNumber": "+905551112233"]
            ),
            (
                CdpUnsubscribePayload(channel: .sms, phoneNumber: "+905551112233"),
                ["channel": "sms", "phoneNumber": "+905551112233"]
            ),
            (
                CdpUnsubscribePayload(channel: .call, phoneNumber: "+905551112233"),
                ["channel": "call", "phoneNumber": "+905551112233"]
            ),
        ]

        for (payload, expected) in cases {
            XCTAssertEqual(payload.toDictionary() as NSDictionary, expected as NSDictionary)
        }
    }

    func testUnsubscribePayloadSerializesIntoUserUnsubscribeRequest() {
        let payload = CdpUnsubscribePayload(
            channel: .whatsapp,
            phoneNumber: "+905551112233"
        ).toDictionary()

        let request = SegmentifyRegisterRequest()
        request.apiKey = "test-api-key"
        request.eventName = CdpEventName.userUnsubscribe
        request.userTraitsProperties = payload

        let dictionary = request.toDictionary()
        let properties = dictionary["properties"] as? [String: Any]

        XCTAssertEqual(dictionary["name"] as? String, "USER_UNSUBSCRIBE")
        XCTAssertEqual(properties?["channel"] as? String, "whatsapp")
        XCTAssertEqual(properties?["phoneNumber"] as? String, "+905551112233")
        XCTAssertNil(properties?["email"])
    }
}
