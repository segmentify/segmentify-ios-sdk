//
//  BannerOperationsModel.swift
//  Segmentify
//

import Foundation

public class BannerOperationsModel:SegmentifyObject{
    public override init() {}
    var title:String?
    var group:String?
    var order:NSNumber?
    var productId:String?
    var category:[String]?
    var brand:String?
    var label:String?
    var type:String?
    var async:Bool?
}
