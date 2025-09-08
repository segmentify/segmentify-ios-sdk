//
//  ProductModel.swift
//  Segmentify

import Foundation
import UIKit

public class NotificationModel: Codable {

    
    public var deviceToken:String?
    public var instanceId:String?
    public var productId:String?
    public var firebaseServerKey:String?
    public var type:NotificationType?
    public var topic:String?
    public var params:[String:String] = [String:String]()
    private var email:String?
    private  var userName:String?
    private  var userId : String?
    private  var osVersion:String?
    private  var os:String?
    public var providerType:ProviderType?

    public  init() {
        
        if(self.type != NotificationType.PERMISSION_INFO){
            self.deviceToken = nil
        }
        
        self.os = "IOS"
        self.osVersion = UIDevice.current.systemVersion
        self.userId = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
        
        let email_ = UserDefaults.standard.object(forKey: "SEGMENTIFY_EMAIL") as? String
        let username_ = UserDefaults.standard.object(forKey: "SEGMENTIFY_USERNAME") as? String
        
        if(email_?.isEmpty == false){  self.email = email_}
        if(username_?.isEmpty == false){  self.userName = username_}
        
        if(self.firebaseServerKey?.isEmpty == true){ self.providerType = ProviderType.APNS } else { self.providerType = ProviderType.FIREBASE}
        
    }
}

