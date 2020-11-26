//
//  ProductModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 22.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

@objc public class ProductRecommendationModel : NSObject,NSCopying {
    
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
    @objc public var params:[String:AnyObject]?
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductRecommendationModel(productId: productId
            , name: name, inStock: inStock, url: url, mUrl: mUrl, image: image, imageXS: imageXS, imageS: imageS, imageM: imageM, imageL: imageL, imageXL: imageXL, category: category, categories: categories, brand: brand, price: price, oldPrice: oldPrice, gender: gender, colors: colors, sizes: sizes, labels: labels, noUpdate: noUpdate, params : params)
        return copy
    }
    
    public override init() {}
    
    public init(productId: String?, name: String?, inStock: Bool?, url: String?, mUrl: String?, image: String?, imageXS: String?, imageS: String?, imageM: String?, imageL: String?, imageXL: String?, category: String?, categories: [String]?, brand: String?, price: NSNumber?, oldPrice: NSNumber?, gender: String?, colors: [String]?, sizes: [String]?, labels: [String]?, noUpdate: Bool?,params: [String:AnyObject]? ) {
        
        self.productId = productId
        self.name = name
        self.inStock = inStock
        self.url = url
        self.mUrl = mUrl
        self.image = image
        self.imageXS = imageXS
        self.imageS = imageS
        self.imageM = imageM
        self.imageL = imageL
        self.imageXL = imageXL
        self.category = category
        self.categories = categories
        self.brand = brand
        self.price = price
        self.oldPrice = oldPrice
        self.gender = gender
        self.colors = colors
        self.sizes = sizes
        self.labels = labels
        self.noUpdate = noUpdate
        self.params = params
    }
    
    
}

