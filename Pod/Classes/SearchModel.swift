//
//  Search.swift
//  Segmentify

import Foundation

public class SearchModel : NSObject, NSCopying {
    public var campaign:SearchCampaignModel?
    public var products:[ProductRecommendationModel]?
    public var errorString:String?
    public var instanceId:String?
    public var interactionId:String?
    
    public  override init() {
        
    }
    
    public init(products: [ProductRecommendationModel], campaign:SearchCampaignModel?, errorString: String?, instanceId: String?, interactionId: String?) {
        self.campaign = campaign
        self.products = products
        self.errorString = errorString
        self.instanceId = instanceId
        self.interactionId = interactionId
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        var mProducts = [ProductRecommendationModel]()
        for p in products! {
            mProducts.append(p.copy() as! ProductRecommendationModel)
        }
        let copy = SearchModel(products: mProducts, campaign: campaign, errorString: errorString, instanceId: instanceId, interactionId: interactionId)
        return copy
    }
        
}
