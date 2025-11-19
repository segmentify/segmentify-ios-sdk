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
    public var additionalImages: [String]?
    public var category: [String]?
    public var categories: [String]?
    public var mainCategory: String?
    public var brand: String?
    public var price: NSNumber?
    public var oldPrice: NSNumber?
    public var gender: String?
    public var colors: [String]?
    public var sizes: [String]?
    public var allSizes: [String]?
    public var labels: [String]?
    public var badges: [String]?
    public var noUpdate: Bool?
    public var params: [String: AnyObject]?
    public var paramsList: [String: [String]]?
    public var priceText: String?
    public var oldPriceText: String?
    public var language: String?
    public var currency: String?
    public var specialPrice: NSNumber?
    public var specialPriceText: String?
    public var lastUpdateTime: Date?
    public var stockCount: NSNumber?
    public var stockRatio: NSNumber?
    public var stockStatus: NSNumber?
    public var publishTime: Date?
    public var combineIds: [String]?
    public var groupId: String?
    public var priceSegment: String?
    public var lastBoughtTime: Date?
    public var scoreCount: NSNumber?
    public var reviewCount: NSNumber?
    public var savingOverTime: NSNumber?
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductRecommendationModel(
            productId: productId,
            name: name,
            inStock: inStock,
            url: url,
            mUrl: mUrl,
            image: image,
            imageXS: imageXS,
            imageS: imageS,
            imageM: imageM,
            imageL: imageL,
            imageXL: imageXL,
            additionalImages: additionalImages,
            category: category,
            categories: categories,
            mainCategory: mainCategory,
            brand: brand,
            price: price,
            oldPrice: oldPrice,
            gender: gender,
            colors: colors,
            sizes: sizes,
            allSizes: allSizes,
            labels: labels,
            badges: badges,
            noUpdate: noUpdate,
            params: params,
            paramsList: paramsList,
            priceText: priceText,
            oldPriceText: oldPriceText,
            language: language,
            currency: currency,
            specialPrice: specialPrice,
            specialPriceText: specialPriceText,
            lastUpdateTime: lastUpdateTime,
            stockCount: stockCount,
            stockRatio: stockRatio,
            stockStatus: stockStatus,
            publishTime: publishTime,
            combineIds: combineIds,
            groupId: groupId,
            priceSegment: priceSegment,
            lastBoughtTime: lastBoughtTime,
            scoreCount: scoreCount,
            reviewCount: reviewCount,
            savingOverTime: savingOverTime
        )
        return copy
    }
    
    public override init() {
    }
    
    public init(
        productId: String?,
        name: String?,
        inStock: Bool?,
        url: String?,
        mUrl: String?,
        image: String?,
        imageXS: String?,
        imageS: String?,
        imageM: String?,
        imageL: String?,
        imageXL: String?,
        additionalImages: [String]?,
        category: [String]?,
        categories: [String]?,
        mainCategory: String?,
        brand: String?,
        price: NSNumber?,
        oldPrice: NSNumber?,
        gender: String?,
        colors: [String]?,
        sizes: [String]?,
        allSizes: [String]?,
        labels: [String]?,
        badges: [String]?,
        noUpdate: Bool?,
        params: [String: AnyObject]?,
        paramsList: [String: [String]]?,
        priceText: String?,
        oldPriceText: String?,
        language: String?,
        currency: String?,
        specialPrice: NSNumber?,
        specialPriceText: String?,
        lastUpdateTime: Date?,
        stockCount: NSNumber?,
        stockRatio: NSNumber?,
        stockStatus: NSNumber?,
        publishTime: Date?,
        combineIds: [String]?,
        groupId: String?,
        priceSegment: String?,
        lastBoughtTime: Date?,
        scoreCount: NSNumber?,
        reviewCount: NSNumber?,
        savingOverTime: NSNumber?
    ) {
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
        self.additionalImages = additionalImages
        self.category = category
        self.categories = categories
        self.mainCategory = mainCategory
        self.brand = brand
        self.price = price
        self.oldPrice = oldPrice
        self.gender = gender
        self.colors = colors
        self.sizes = sizes
        self.allSizes = allSizes
        self.labels = labels
        self.badges = badges
        self.noUpdate = noUpdate
        self.params = params
        self.paramsList = paramsList
        self.priceText = priceText
        self.oldPriceText = oldPriceText
        self.language = language
        self.currency = currency
        self.specialPrice = specialPrice
        self.specialPriceText = specialPriceText
        self.lastUpdateTime = lastUpdateTime
        self.stockCount = stockCount
        self.stockRatio = stockRatio
        self.stockStatus = stockStatus
        self.publishTime = publishTime
        self.combineIds = combineIds
        self.groupId = groupId
        self.priceSegment = priceSegment
        self.lastBoughtTime = lastBoughtTime
        self.scoreCount = scoreCount
        self.reviewCount = reviewCount
        self.savingOverTime = savingOverTime
    }
}

