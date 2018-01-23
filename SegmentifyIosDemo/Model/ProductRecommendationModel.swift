//
//  ProductModel.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 8.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import Foundation

class ProductRecommendationModel : NSCopying {
    
    var brand:String?
    var currency:String?
    var image:String?
    var inStock:Bool?
    var insertTime:Int?
    var language:String?
    var lastUpdateTime:Int?
    var name:String?
    var oldPriceText:String?
    var price:Int?
    var priceText:String?
    var url:String?
    var productId:String?
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductRecommendationModel(brand: brand!, currency: currency!, image: image!, inStock: inStock!, inserTime: insertTime!, language: language!, lastUpdateTime: lastUpdateTime!, name: name!, oldPriceText: oldPriceText!, price: price, priceText: priceText!, url: url, productId: productId!)
        return copy
    }
    
    init() {
        
    }
    
    init(brand: String, currency: String, image: String, inStock: Bool, inserTime: Int, language: String, lastUpdateTime:Int?, name: String, oldPriceText: String, price: Int?, priceText: String, url: String?, productId: String) {
      
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
