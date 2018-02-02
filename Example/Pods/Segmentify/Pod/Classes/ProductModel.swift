//
//  ProductModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

public class ProductModel:SegmentifyObject {
    public override init() {}
    public var productId:String?
    public var title:String?
    public var inStock:Bool?
    public var url:String?
    public var mUrl:String?
    public var image:String?
    public var imageXS:String?
    public var imageS:String?
    public var imageM:String?
    public var imageL:String?
    public var imageXL: String?
    public var category:String?
    public var categories:[String]?
    public var brand:String?
    public var price:NSNumber?
    public var oldPrice:NSNumber?
    public var gender:String?
    public var colors:[String]?
    public var sizes:[String]?
    public var labels:[String]?
    public var noUpdate:Bool?
}
