import Foundation

public enum CdpConsent: String {
    case subscribed = "SUBSCRIBED"
    case unsubscribed = "UNSUBSCRIBED"
    case notSet = "NOT_SET"
}

let cdpConsentFields = [
    "callConsent",
    "emailConsent",
    "whatsappConsent",
    "smsConsent",
]

func withConsentDefaults(_ params: [String: Any]) -> [String: Any]? {
    guard !params.isEmpty else {
        return nil
    }

    var clonedParams = deepCopyDictionary(params)
    let includesConsent = cdpConsentFields.contains { params[$0] != nil }

    guard includesConsent else {
        return clonedParams
    }

    for field in cdpConsentFields where clonedParams[field] == nil {
        clonedParams[field] = CdpConsent.notSet.rawValue
    }

    return clonedParams
}

func deepCopyDictionary(_ dictionary: [String: Any]) -> [String: Any] {
    guard JSONSerialization.isValidJSONObject(dictionary),
          let data = try? JSONSerialization.data(withJSONObject: dictionary),
          let copy = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        return dictionary
    }
    return copy
}
