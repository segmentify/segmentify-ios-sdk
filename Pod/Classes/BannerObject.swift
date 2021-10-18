//
//  BannerObject.swift
//  Segmentify
//


import Foundation

public class BannerObject: NSObject{
    public var title:String?
    public var group:String?
    public var order:NSNumber?
    
    var dictionary: [String: Any] {
        return ["title": title as Any,
                "group": group as Any,
                "order": order as Any]
    }
    public var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
