//
//  SegmentifyObject.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 22.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

@objc public class SegmentifyObject:NSObject {
    @objc public override init() {}
    @objc public var sessionID:String?
    @objc public var pageUrl:String?
    @objc public var currency:String?
    @objc public var lang:String?
    @objc public var params:[String:AnyObject]?
    public var nextPage: Bool?
    public var testMode: Bool?
}
