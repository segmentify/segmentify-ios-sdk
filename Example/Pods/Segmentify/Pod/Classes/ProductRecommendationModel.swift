//
//  ProductModel.swift
//  Segmentify

import Foundation

public class ProductRecommendationModel: NSObject, NSCopying {

    public var productId: String?
    public var name: String?
    public var inStock: Bool?
    public var url: String?
    public var mUrl: String?
    public var image: String?
    public var imageXS: String?
    public var imageS: String?
    public var imageM: String?
    public var imageL: String?
    public var imageXL: String?
    public var category: [String]?
    public var categories: [String]?
    public var brand: String?
    public var price: NSNumber?
    public var oldPrice: NSNumber?
    public var gender: String?
    public var colors: [String]?
    public var sizes: [String]?
    public var labels: [String]?
    public var noUpdate: Bool?
    public var params: [String: AnyObject]?
    public var priceText: String?
    public var oldPriceText: String?
    public var language: String?
    public var currency: String?
    public var specialPrice: NSNumber?
    public var specialPriceText: String?

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductRecommendationModel(productId: productId, name: name, inStock: inStock, url: url, mUrl: mUrl,
                image: image, imageXS: imageXS, imageS: imageS, imageM: imageM, imageL: imageL, imageXL: imageXL, category: category,
                categories: categories, brand: brand, price: price, oldPrice: oldPrice, gender: gender, colors: colors, sizes: sizes,
                labels: labels, noUpdate: noUpdate, params: params, priceText: priceText, oldPriceText: oldPriceText,
                language: language, currency: currency, specialPrice: specialPrice, specialPriceText: specialPriceText)
        return copy
    }

    public override init() {
    }

    public init(productId: String?, name: String?, inStock: Bool?, url: String?, mUrl: String?, image: String?, imageXS: String?,
                imageS: String?, imageM: String?, imageL: String?, imageXL: String?, category: [String]?, categories: [String]?,
                brand: String?, price: NSNumber?, oldPrice: NSNumber?, gender: String?, colors: [String]?, sizes: [String]?,
                labels: [String]?, noUpdate: Bool?, params: [String: AnyObject]?, priceText: String?, oldPriceText: String?,
                language: String?, currency: String?, specialPrice: NSNumber?, specialPriceText: String?) {

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
        self.language = language
        self.currency = currency
        self.specialPrice = specialPrice
        self.specialPriceText = specialPriceText
    }
}

