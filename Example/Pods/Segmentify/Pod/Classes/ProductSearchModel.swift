//
//  ProductSearchModel.swift
//  Pods
//
//  Created by Ebru Goksal on 8.01.2020.
//

import Foundation

public class ProductSearchModel : NSObject, NSCopying, Codable {
    
    public var productId:String?
    public var name:String?
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
    public var price:Double?
    public var oldPrice:Double?
    public var gender:String?
    public var colors:[String]?
    public var sizes:[String]?
    public var labels:[String]?
    public var noUpdate:Bool?
    public var params:[String:String]?
    public var priceText:String?
    public var oldPriceText:String?
    public var specialPriceText:String?
    public var language:String?
    public var currency:String?
    public var quantity:String?
    
    enum CodingKeys: String, CodingKey {
      case productId
      case name
      case inStock
      case url
      case mUrl
      case image
      case imageXS
      case imageS
      case imageM
      case imageL
      case imageXL
      case category
      case categories
      case brand
      case price
      case oldPrice
      case gender
      case colors
      case sizes
      case labels
      case noUpdate
      case params
      case priceText
      case oldPriceText
      case specialPriceText
      case language
      case currency
      case quantity
    }
    
    required public init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
           productId = try values.decode(String?.self, forKey: .productId)
           name = try values.decode(String?.self, forKey: .name)
           inStock = try values.decode(Bool?.self, forKey: .inStock)
           url = try values.decode(String?.self, forKey: .url)
           mUrl = try values.decode(String?.self, forKey: .mUrl)
           image = try values.decode(String?.self, forKey: .image)
           imageXS = try values.decode(String?.self, forKey: .imageXS)
           imageS = try values.decode(String?.self, forKey: .imageS)
           imageM = try values.decode(String?.self, forKey: .imageM)
           imageL = try values.decode(String?.self, forKey: .imageL)
           imageXL = try values.decode( String?.self, forKey: .imageXL)
           category = try values.decode(String?.self, forKey: .category)
           categories = try values.decode([String]?.self, forKey: .categories)
           brand = try values.decode(String?.self, forKey: .brand)
           gender = try values.decode(String?.self, forKey: .gender)
           colors = try values.decode([String]?.self, forKey: .colors)
           sizes = try values.decode([String]?.self, forKey: .sizes)
           labels = try values.decode([String]?.self, forKey: .labels)
           noUpdate = try values.decode(Bool?.self, forKey: .noUpdate)
           params = try values.decode([String:String].self, forKey: .params)
           priceText = try values.decode(String?.self, forKey: .priceText)

            price = try values.decode(Double?.self, forKey: .price)
          oldPrice = try values.decode(Double?.self, forKey: .oldPrice)
           oldPriceText = try values.decode(String?.self, forKey: .oldPriceText)
           specialPriceText = try values.decode(String?.self, forKey: .specialPriceText)
           language = try values.decode(String?.self, forKey: .language)
           currency = try values.decode(String?.self, forKey: .currency)
           quantity = try values.decode(String?.self, forKey: .quantity)
       }
    
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductSearchModel(productId: productId
            , name: name, inStock: inStock, url: url, mUrl: mUrl, image: image, imageXS: imageXS, imageS: imageS, imageM: imageM, imageL: imageL, imageXL: imageXL, category: category, categories: categories, brand: brand, price: price, oldPrice: oldPrice, gender: gender, colors: colors, sizes: sizes, labels: labels, noUpdate: noUpdate, params : params, priceText : priceText, oldPriceText : oldPriceText, specialPriceText : specialPriceText, language : language, currency : currency,  quantity : quantity)
        return copy
    }
    
    public override init() {}
    
    public init(productId: String?, name: String?, inStock: Bool?, url: String?, mUrl: String?, image: String?, imageXS: String?, imageS: String?, imageM: String?, imageL: String?, imageXL: String?, category: String?, categories: [String]?, brand: String?, price: Double?, oldPrice: Double?, gender: String?, colors: [String]?, sizes: [String]?, labels: [String]?, noUpdate: Bool?,params: [String:String]?, priceText: String?, oldPriceText: String?, specialPriceText: String?, language: String?, currency: String?, quantity: String?) {
        
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
        self.priceText = priceText
        self.oldPriceText = oldPriceText
        self.specialPriceText = specialPriceText
        self.language = language
        self.currency = currency
        self.quantity = quantity
    }
    
    
}

