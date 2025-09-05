//
//  AppDelegate.swift
//  Segmentify-Demo

import UIKit
import Segmentify
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Change your appKey, dataCenterUrl and subDomain values with suitable one
        SegmentifyManager.config(appkey: "3c9e211a-d049-43d5-aa4a-f98b7e66e482", dataCenterUrl: "https://gandalf-qa.segmentify.com", subDomain: "demosfy.com")
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
