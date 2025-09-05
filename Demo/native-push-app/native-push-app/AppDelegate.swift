import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import Segmentify

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self

        Messaging.messaging().delegate = self
        
        // Change your appKey, dataCenterUrl and subDomain values with suitable one
        SegmentifyManager.config(appkey: "3c9e211a-d049-43d5-aa4a-f98b7e66e482", dataCenterUrl: "https://gandalf-qa.segmentify.com", subDomain: "demosfy.com")
        SegmentifyManager.setPushConfig(dataCenterUrlPush: "https://gimli-qa.segmentify.com")
        let _ = SegmentifyManager.logStatus(isVisible: true)
        let _ = SegmentifyManager.setSessionKeepSecond(sessionKeepSecond: 604800)

        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let hex = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token: \(hex)")
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs kaydı başarısız: \(error)")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification granted, userInfo: \(userInfo)")
        completionHandler()
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM registration token retrieved: \(String(describing: fcmToken))")
        NotificationCenter.default.post(name: .fcmTokenUpdated, object: fcmToken)

        // Send FCM token info to Segmentify
        let obj = NotificationModel()
        obj.deviceToken = fcmToken ?? ""
        obj.type = NotificationType.PERMISSION_INFO
        obj.providerType = ProviderType.FIREBASE
        SegmentifyManager.sharedManager().sendNotification(segmentifyObject: obj)
    }
}

extension Notification.Name {
    static let fcmTokenUpdated = Notification.Name("fcmTokenUpdated")
}
