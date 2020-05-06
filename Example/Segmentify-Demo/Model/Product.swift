//
//  Product.swift
//  Segmentify-Demo


import Foundation
public class Product {
    var image : String?
    var name : String?
    var price: NSNumber?
    var oldPrice: Int?
    var productId: String?
    var brand: String?
    var url: String?
    var inStock: Bool?
    var category: [String]?
    var categories: [String]?
    var count: Int!
    
    init() {}

    init(image: String?, name: String?, price : NSNumber?, oldPrice: Int?, productId: String?, brand: String?, url: String?, inStock: Bool?, category: [String]?, categories: [String]?) {
        self.image = image
        self.name = name
        self.price = price!
        self.oldPrice = oldPrice
        self.productId = productId
        self.brand = brand
        self.url = url
        self.inStock = inStock
        self.category = category
        self.categories = categories
        self.count = 0
    }
}
