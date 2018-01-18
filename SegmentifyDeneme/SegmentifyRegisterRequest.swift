//
//  SegmentifyRegisterRequest.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

class SegmentifyRegisterRequest : SegmentifyRequestProtocol {
    var path = "subscription"
    var port = "4243"
    var method = "POST"
    var subdomain = ""
    var dataCenterUrl:String = ""
    
    var segmentifyObj:SegmentifyObject?
    
    var token:String?
    var appKey:String?
    var os:String?
    var osVersion:String?
    var deviceType:String?
    var deviceName:String?
    var carrier:String = ""
    var local:String?
    var appVersion:String?
    var sdkVersion:String?
    var firstTime:NSNumber?
    var advertisingIdentifier:String?
    var category:String?
    var categories : [String]?
    var subCategory:String?
    var eventName:String?
    var productID:String?
    var title:String?
    var brand:String?
    var currency:String?
    var price:NSNumber?
    var totalPrice:NSNumber?
    var stock:Bool?
    var basketStep:String?
    var basketID:String?
    var quantity:NSNumber?
    var orderNo:String?
    var products:[Any]?
    var checkoutStep:String?
    var username:String?
    var userID:String?
    var sessionID:String?
    var email:String?
    var age:String?
    var birthdate:String?
    var gender:String?
    var fullName:String?
    var mobilePhone:String?
    var isRegistered:Bool?
    var isLogin:Bool?
    var userOperationStep:String?
    var pageUrl:String?
    var image:String?
    var url:String?
    var memberSince:String?
    var oldUserId:String?
    var lang:String?
    var mUrl:String?
    var imageXS:String?
    var imageS:String?
    var imageL:String?
    var imageXL:String?
    var colors:[String]?
    var sizes:[String]?
    var labels:[String]?
    var location:String?
    var segments:[String]?
    var type:String?
    var params:AnyObject?
    var instanceId:String?
    var interactionId:String?
    
    
    var extra: [AnyHashable: Any] = [AnyHashable: Any]()
    
    init() {
        let device = UIDevice.current
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceType = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let provider = CTTelephonyNetworkInfo.init().subscriberCellularProvider
        
        if let code = provider?.mobileCountryCode {
            if let networkCode = provider?.mobileNetworkCode {
                self.carrier = "\(code)\(networkCode)"
            }
        }
        
        self.deviceType = deviceType
        self.os = device.systemName
        self.osVersion = device.systemVersion
        self.deviceName = device.name
        self.local = NSLocale.preferredLanguages.first
        self.firstTime = NSNumber.init(value: 1)
    }
    
    init(withDictionary dictionary: Dictionary<AnyHashable, Any>) {
        self.token = dictionary["token"] as? String
        self.appKey = dictionary["appKey"] as? String
        self.os = dictionary["os"] as? String
        self.osVersion = dictionary["osVersion"] as? String
        self.deviceType = dictionary["deviceType"] as? String
        self.deviceName = dictionary["deviceName"] as? String
        if let c = dictionary["carrier"] {
            self.carrier = c as! String
        }
        else {
            self.carrier = ""
        }
        self.local = dictionary["local"] as? String
        self.appVersion = dictionary["appVersion"] as? String
        self.sdkVersion = dictionary["sdkVersion"] as? String
        self.firstTime = dictionary["firstTime"] as? NSNumber
        self.advertisingIdentifier = dictionary["advertisingIdentifier"] as? String

        if let extra = dictionary["extra"] {
            segmentifyObj?.extra = extra as! [AnyHashable: Any]
        }
        else {
            segmentifyObj?.extra = [AnyHashable: Any]()
        }
    }
    
    func toDictionary() -> Dictionary<AnyHashable, Any> {
        var dictionary = [AnyHashable: Any]()
        
        if let token = self.token {
            dictionary["token"] = token as Any?
        }
        if let appKey = self.appKey {
            dictionary["appKey"] = appKey as Any?
        }
        if let os = self.os {
            //TODO
            //dictionary["os"] = os as Any?
            dictionary["os"] = "ios"
        }
        
        if let device = self.os {
            dictionary["device"] = "ios"
        }
        
        if let osVersion = self.osVersion {
            dictionary["osversion"] = osVersion as Any?
        }
        if let deviceType = self.deviceType {
            dictionary["deviceType"] = deviceType as Any?
        }
        if let deviceName = self.deviceName {
            dictionary["deviceName"] = deviceName as Any?
        }
        
        dictionary["carrier"] = carrier as Any?
        
        if let local = self.local {
            dictionary["local"] = local as Any?
        }
        if let appVersion = self.appVersion {
            dictionary["appVersion"] = appVersion as Any?
        }
        if let sdkVersion = self.sdkVersion {
            dictionary["sdkVersion"] = sdkVersion as Any?
        }
        if let firstTime = self.firstTime {
            dictionary["firstTime"] = firstTime.uintValue as Any?
        }

        if let advertisingIdentifier = self.advertisingIdentifier {
            dictionary["advertisingIdentifier"] = advertisingIdentifier as Any?
        }
        
        if let eventName = self.eventName {
            dictionary["name"] = eventName as Any?
        }

        if let category = self.category {
            dictionary["category"] = category as Any?
        }

        if let subCategory = self.subCategory {
            dictionary["subCategory"] = subCategory as Any?
        }

        if let productID = self.productID {
            dictionary["productId"] = productID as Any?
        }

        if let title = self.title {
            dictionary["title"] = title as Any?
        }

        if let brand = self.brand {
            dictionary["brand"] = brand as Any?
        }

        if let price = self.price {
            dictionary["price"] = price as Any?
        }

        if let totalPrice = self.totalPrice {
            dictionary["totalPrice"] = totalPrice as Any?
        }

        if let gender = self.gender {
            dictionary["gender"] = gender as Any?
        }

        if let age = self.age {
            dictionary["age"] = age as Any?
        }

        if let memberSince = self.memberSince {
            dictionary["memberSince"] = memberSince as Any?
        }
        if let lang = self.lang {
            dictionary["lang"] = lang as Any?
        }

        if let currency = self.currency {
            dictionary["currency"] = currency as Any?
        }

        if let quantity = self.quantity {
            dictionary["quantity"] = quantity as Any?
        }

        if let basketID = self.basketID {
            dictionary["basketId"] = basketID as Any?
        }

        if let products = self.products {
            dictionary["productList"] = products as Any
        }
        
        if let userID = self.userID {
            dictionary["userId"] = userID as Any?
        }
        
        if let sessionId = self.sessionID as Any? {
            dictionary["sessionId"] = sessionId as Any?
        }
        
        if let userOperationStep = self.userOperationStep {
            dictionary["step"] = userOperationStep
        }
        
        if let pageUrl = self.pageUrl {
            dictionary["pageUrl"] = pageUrl
        }
        
        if let image = self.image {
            dictionary["image"] = image
        }
        
        if let categories = self.categories {
            dictionary["categories"] = categories
        }
        
        if let url = self.url {
            dictionary["url"] = url
        }
        
        if let checkoutStep = self.checkoutStep {
            dictionary["step"] = checkoutStep
        }
        
        if let basketStep = self.basketStep {
            dictionary["step"] = basketStep
        }
        
        if let orderNo = self.orderNo {
            dictionary["orderNo"] = orderNo
        }
        
        if let oldUserId = self.oldUserId {
            dictionary["oldUserId"] = oldUserId
        }

        if let interactionId = self.interactionId {
            dictionary["interactionId"] = interactionId
        }
        
        if let instanceId = self.instanceId {
            dictionary["instanceId"] = instanceId
        }
        
        dictionary["extra"] = extra as Any?

        return dictionary
    }
    
    convenience init?(withJsonString jsonString: String) {
        let dictionary = SegmentifyTools.convertJsonStringToDictionary(text: jsonString)
        guard dictionary != nil else {
            return nil
        }
        self.init(withDictionary: dictionary!)
    }
    
    func toJsonString() -> String? {
        let dictionary = self.toDictionary()
        if let string = SegmentifyTools.convertDictionaryToJsonString(dictionary: dictionary) {
            return string
        }
        return nil
    }
}

