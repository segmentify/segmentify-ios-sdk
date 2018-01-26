//
//  ProductModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 22.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

public class ProductRecommendationModel : NSCopying {
    
    public var brand:String?
    public var currency:String?
    public var image:String?
    public var inStock:Bool?
    public var insertTime:Int?
    public var language:String?
    public var lastUpdateTime:Int?
    public var name:String?
    public var oldPriceText:String?
    public var price:Int?
    public var priceText:String?
    public var url:String?
    public var productId:String?
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductRecommendationModel(brand: brand!, currency: currency!, image: image!, inStock: inStock!, inserTime: insertTime!, language: language!, lastUpdateTime: lastUpdateTime!, name: name!, oldPriceText: oldPriceText!, price: price, priceText: priceText!, url: url, productId: productId!)
        return copy
    }
    
    
   public init(brand: String, currency: String, image: String, inStock: Bool, inserTime: Int, language: String, lastUpdateTime:Int?, name: String, oldPriceText: String, price: Int?, priceText: String, url: String?, productId: String) {
        
        self.brand = brand
        self.currency = currency
        self.image = image
        self.inStock = inStock
        self.insertTime = inserTime
        self.language = language
        self.lastUpdateTime = lastUpdateTime
        self.name = name
        self.oldPriceText = oldPriceText
        self.price = price
        self.priceText = priceText
        self.url = url
        self.productId = productId
    }
    
    
}

