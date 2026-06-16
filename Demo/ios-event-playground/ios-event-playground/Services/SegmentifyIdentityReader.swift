import Foundation

enum SegmentifyIdentityReader {
    static func currentIdentity() -> (userId: String, sessionId: String) {
        let defaults = UserDefaults.standard
        let userId =
            (defaults.string(forKey: "UserSentUserId"))
            ?? (defaults.string(forKey: "SEGMENTIFY_USER_ID"))
            ?? "—"
        let sessionId = defaults.string(forKey: "SEGMENTIFY_SESSION_ID") ?? "—"
        return (userId, sessionId)
    }

    static func currentUserId() -> String? {
        let userId = currentIdentity().userId
        return userId == "—" ? nil : userId
    }
}
