//
//  Search.swift
//  Segmentify

import Foundation

public class SearchModel : NSObject, NSCopying {
    public var campaign:SearchCampaignModel?
    public var products:[ProductRecommendationModel]?
    public var categoryProducts = [String:[ProductRecommendationModel]]()
    public var keywords = [String: [ProductRecommendationModel]]()
    public var brandProducts = [String: [ProductRecommendationModel]]()
    public var brands = [String: String]()
    public var categories = [String: String]()
    public var lastSearches = [String]()
    public var errorString:String?
    public var instanceId:String?
    public var interactionId:String?
    
    public  override init() {
        
    }
    
    public init(products: [ProductRecommendationModel], campaign:SearchCampaignModel?, errorString: String?, instanceId: String?, interactionId: String?,
                categoryProducts: [String:[ProductRecommendationModel]],keywords: [String:[ProductRecommendationModel]], brands:[String:String],
                brandProducts: [String:[ProductRecommendationModel]], categories: [String:String], lastSearches: [String]) {
        self.campaign = campaign
        self.products = products
        self.errorString = errorString
        self.instanceId = instanceId
        self.interactionId = interactionId
        self.categoryProducts = categoryProducts
        self.keywords = keywords
        self.brands = brands
        self.brandProducts = brandProducts
        self.categories = categories
        self.lastSearches = lastSearches
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        var mProducts = [ProductRecommendationModel]()
        for p in products! {
            mProducts.append(p.copy() as! ProductRecommendationModel)
        }
        
        let copy = SearchModel(products: mProducts, campaign: campaign, errorString: errorString, instanceId: instanceId, interactionId: interactionId,
                               categoryProducts: categoryProducts, keywords: keywords, brands:brands, brandProducts: brandProducts, categories: categories,
                               lastSearches: lastSearches)
        return copy
    }
        
}
