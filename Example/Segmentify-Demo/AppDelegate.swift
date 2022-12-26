//
//  AppDelegate.swift
//  Segmentify-Demo

import UIKit
import Segmentify
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // define Segmentify config
        FirebaseApp.configure()
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
            if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self

              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
              )
            } else {
              let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }

            application.registerForRemoteNotifications()

            // [END register_for_notifications]
        
         SegmentifyManager.config(appkey: "ae272bfb-214b-4cdd-b5c4-1dddde09e95e", dataCenterUrl: "https://gandalf-dev.segmentify.com", subDomain: "dev-segmentify.com")
         SegmentifyManager.setPushConfig(dataCenterUrlPush: "https://gimli-dev.segmentify.com")
        // option to show or hide console log
        let _ = SegmentifyManager.logStatus(isVisible: true)
        let _ = SegmentifyManager.setSessionKeepSecond(sessionKeepSecond: 604800)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("willresignactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("didenterbackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("willenterbackground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("didbecomeactive")
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if(application.applicationState == UIApplication.State.inactive){
            print("inactive")
        }
        
        if(application.applicationState == UIApplication.State.active){
            print("active")
        }
        
        if(application.applicationState == UIApplication.State.background){

            let apns_instanceId = userInfo["instanceId"]
            let f_instanceId = userInfo["gcm.notification.instanceId"]
            var instanceId_  = ""
            
            if(apns_instanceId != nil){
                instanceId_ = apns_instanceId as! String
            }
            else if(f_instanceId != nil){
                instanceId_ = f_instanceId as! String
            }

            let obj = NotificationModel()
            obj.instanceId = instanceId_
            obj.params = ["price": "123", "productId": "13", "quantity": "132"]
            obj.type = NotificationType.VIEW
            
            SegmentifyManager.sharedManager().sendNotificationInteraction(segmentifyObject: obj)

        }
        // Print full message.
        print(userInfo)
    }
    

    // [START receive_message]
      func application(_ application: UIApplication,
                       didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                         -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
      }

      // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNs token retrieved: \(deviceToken)")
        let   tokenString = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        print("deviceToken: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        print(userInfo["gcm.notification.instanceId"])
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

                
        let apns_instanceId = userInfo["instanceId"]
        let f_instanceId = userInfo["gcm.notification.instanceId"]
        var instanceId_  = ""
        
        let apns_productId = userInfo["productId"]
        let f_productId = userInfo["gcm.notification.productId"]
        var productId_  = ""
        
        if(apns_instanceId != nil){
            instanceId_ = apns_instanceId as! String
        }
        else if(f_instanceId != nil){
            instanceId_ = f_instanceId as! String
        }
        
        if(apns_productId != nil){
            productId_ = apns_productId as! String
        }
        else if(f_productId  != nil){
            productId_ = f_productId  as! String
        }
   

        _ = SegmentifyManager.sharedManager().getTrackingParameters();
        let obj = NotificationModel()
        obj.instanceId = instanceId_
        obj.productId = productId_
        obj.type = NotificationType.CLICK

        SegmentifyManager.sharedManager().sendNotificationInteraction(segmentifyObject: obj)
        
        // Print full message.
        print(userInfo)

        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        let obj = NotificationModel()
        obj.deviceToken = fcmToken
        obj.type = NotificationType.PERMISSION_INFO
        obj.providerType = ProviderType.FIREBASE
        SegmentifyManager.sharedManager().sendNotification(segmentifyObject: obj)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
}
