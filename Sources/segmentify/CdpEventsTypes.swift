import Foundation

public enum CdpChannel: String {
    case apns = "apns"
    case email = "email"
    case whatsapp = "whatsapp"
    case sms = "sms"
    case call = "call"
}

public typealias CdpEventsPayload = [String: Any]

public enum CdpSubscribePayload {
    case apns(pushSubscriptionId: String)
    case email(email: String, purpose: String)
    case whatsapp(phoneNumber: String)
    case sms(phoneNumber: String)
    case call(phoneNumber: String)

    public func toDictionary() -> [String: Any] {
        switch self {
        case let .apns(pushSubscriptionId):
            return [
                "channel": CdpChannel.apns.rawValue,
                "pushSubscriptionId": pushSubscriptionId,
            ]
        case let .email(email, purpose):
            return [
                "channel": CdpChannel.email.rawValue,
                "email": email,
                "purpose": purpose,
            ]
        case let .whatsapp(phoneNumber):
            return [
                "channel": CdpChannel.whatsapp.rawValue,
                "phoneNumber": phoneNumber,
            ]
        case let .sms(phoneNumber):
            return [
                "channel": CdpChannel.sms.rawValue,
                "phoneNumber": phoneNumber,
            ]
        case let .call(phoneNumber):
            return [
                "channel": CdpChannel.call.rawValue,
                "phoneNumber": phoneNumber,
            ]
        }
    }
}

public struct CdpUnsubscribePayload {
    public let channel: CdpChannel
    public let email: String?
    public let phoneNumber: String?

    public init(channel: CdpChannel, email: String? = nil, phoneNumber: String? = nil) {
        self.channel = channel
        self.email = email
        self.phoneNumber = phoneNumber
    }

    public func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = ["channel": channel.rawValue]

        if let email {
            dictionary["email"] = email
        }
        if let phoneNumber {
            dictionary["phoneNumber"] = phoneNumber
        }

        return dictionary
    }
}

enum CdpEventName {
    static let userTraits = "USER_TRAITS"
    static let userIdentify = "USER_IDENTIFY"
    static let userRegister = "USER_REGISTER"
    static let userLogin = "USER_LOGIN"
    static let userLogout = "USER_LOGOUT"
    static let userSubscribe = "USER_SUBSCRIBE"
    static let userUnsubscribe = "USER_UNSUBSCRIBE"

    static let eventsWithProperties: Set<String> = [
        userTraits,
        userIdentify,
        userRegister,
        userLogin,
        userLogout,
        userSubscribe,
        userUnsubscribe,
    ]
}
