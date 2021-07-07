//
//  SegmentifyObject.swift
//  Segmentify

import Foundation

public class SegmentifyObject:NSObject {
    public override init() {}
    public var sessionID:String?
    public var pageUrl:String?
    public var currency:String?
    public var lang:String?
    public var params:[String:AnyObject]?
    public var nextPage: Bool?
    public var testMode: Bool?
    public var region: String?
}
