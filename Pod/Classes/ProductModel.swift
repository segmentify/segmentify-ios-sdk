//
//  ProductModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

@objc public class ProductModel:SegmentifyObject {
    @objc public override init() {}
    @objc public var productId:String?
    @objc public var name:String?
    public var inStock:Bool?
    @objc public var url:String?
    @objc public var mUrl:String?
    @objc public var image:String?
    @objc public var imageXS:String?
    @objc public var imageS:String?
    @objc public var imageM:String?
    @objc public var imageL:String?
    @objc public var imageXL: String?
    @objc public var category:String?
    @objc public var categories:[String]?
    @objc public var brand:String?
    @objc public var price:NSNumber?
    @objc public var oldPrice:NSNumber?
    @objc public var gender:String?
    @objc public var colors:[String]?
    @objc public var sizes:[String]?
    @objc public var labels:[String]?
    public var noUpdate:Bool?
}
