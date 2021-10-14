//
//  BannerOperationsModel.swift
//  Segmentify
//

import Foundation

public class BannerOperationsModel:SegmentifyObject{
    public override init() {}
    public var title:String?
    public var group:String?
    public var order:NSNumber?
    public var productId:String?
    public var category:[String]?
    public var brand:String?
    public var label:String?
    public var type:String?
    public var async:Bool?
}
