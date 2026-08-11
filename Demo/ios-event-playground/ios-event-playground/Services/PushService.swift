import FirebaseMessaging
import Foundation
import UIKit
import UserNotifications

@MainActor
final class PushService: ObservableObject {
    @Published private(set) var statusMessage = "Push listeners not started"
    @Published private(set) var fcmToken: String?

    func start() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            Task { @MainActor in
                if let error {
                    self.statusMessage = "Push permission failed: \(error.localizedDescription)"
                    return
                }
                self.statusMessage = granted ? "Push permission granted" : "Push permission denied"
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        NotificationCenter.default.addObserver(
            forName: .fcmTokenUpdated,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            Task { @MainActor in
                self?.fcmToken = notification.object as? String
                if let token = self?.fcmToken {
                    self?.statusMessage = "FCM token available (\(token.prefix(12))...)"
                }
            }
        }

        Messaging.messaging().token { [weak self] token, error in
            Task { @MainActor in
                if let token {
                    self?.fcmToken = token
                    self?.statusMessage = "FCM token available (\(token.prefix(12))...)"
                } else if let error {
                    self?.statusMessage = "FCM token error: \(error.localizedDescription)"
                }
            }
        }
    }

    func ensureToken() async throws -> String {
        if let fcmToken, !fcmToken.isEmpty {
            return fcmToken
        }

        return try await withCheckedThrowingContinuation { continuation in
            Messaging.messaging().token { token, error in
                if let token, !token.isEmpty {
                    Task { @MainActor in
                        self.fcmToken = token
                        self.statusMessage = "FCM token available (\(token.prefix(12))...)"
                    }
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(
                        throwing: error ?? NSError(
                            domain: "PushService",
                            code: 1,
                            userInfo: [NSLocalizedDescriptionKey: "Firebase/device token not available. Check permission and device support."]
                        )
                    )
                }
            }
        }
    }
}

extension Notification.Name {
    static let fcmTokenUpdated = Notification.Name("fcmTokenUpdated")
}
