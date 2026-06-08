import XCTest
@testable import Segmentify

final class ConsentDefaultsTests: XCTestCase {
    func testEmptyParamsReturnsNil() {
        XCTAssertNil(withConsentDefaults([:]))
    }

    func testParamsWithoutConsentFieldsReturnsUnchangedClone() {
        let params: [String: Any] = [
            "email": "user@example.com",
            "username": "johndoe",
        ]

        let result = withConsentDefaults(params)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?["email"] as? String, "user@example.com")
        XCTAssertEqual(result?["username"] as? String, "johndoe")
        XCTAssertNil(result?["emailConsent"])
        var mutableParams = params
        mutableParams["email"] = "changed@example.com"
        XCTAssertEqual(result?["email"] as? String, "user@example.com")
    }

    func testPartialConsentFieldsFilledWithNotSet() {
        let params: [String: Any] = [
            "email": "user@example.com",
            "emailConsent": CdpConsent.subscribed.rawValue,
        ]

        let result = withConsentDefaults(params)

        XCTAssertEqual(result?["emailConsent"] as? String, CdpConsent.subscribed.rawValue)
        XCTAssertEqual(result?["callConsent"] as? String, CdpConsent.notSet.rawValue)
        XCTAssertEqual(result?["whatsappConsent"] as? String, CdpConsent.notSet.rawValue)
        XCTAssertEqual(result?["smsConsent"] as? String, CdpConsent.notSet.rawValue)
    }

    func testExplicitConsentValuesPreserved() {
        let params: [String: Any] = [
            "emailConsent": CdpConsent.unsubscribed.rawValue,
            "callConsent": CdpConsent.subscribed.rawValue,
            "whatsappConsent": CdpConsent.notSet.rawValue,
            "smsConsent": CdpConsent.subscribed.rawValue,
        ]

        let result = withConsentDefaults(params)

        XCTAssertEqual(result?["emailConsent"] as? String, CdpConsent.unsubscribed.rawValue)
        XCTAssertEqual(result?["callConsent"] as? String, CdpConsent.subscribed.rawValue)
        XCTAssertEqual(result?["whatsappConsent"] as? String, CdpConsent.notSet.rawValue)
        XCTAssertEqual(result?["smsConsent"] as? String, CdpConsent.subscribed.rawValue)
    }
}
