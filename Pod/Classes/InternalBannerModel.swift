//
//  InternalBannerModel.swift
//  Segmentify
//


import Foundation

public class InternalBannerModel{
    public init() {}
    public var title:String?
    public var image:String?
    public var order:NSNumber?
    public var urls:[String]?
    
    var dictionary: [String: Any] {
        return ["title": title as Any,
                "image": image as Any,
                "order": order as Any,
                "urls":urls as Any]
    }
    public var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
