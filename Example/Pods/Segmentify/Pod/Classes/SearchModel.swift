//
//  Search.swift
//  Pods
//
//  Created by Ebru Goksal on 8.01.2020.
//

import Foundation

public class SearchModel : NSObject, NSCopying, Codable {
    public var campaign:SearchCampaignModel?
    public var products:[ProductSearchModel]?
    public var errorString:String?
    public var instanceId:String?
    public var interactionId:String?
    enum CodingKeys: String, CodingKey {
        case campaign
        case products
        case errorString
        case instanceId
        case interactionId
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        campaign = try values.decode(SearchCampaignModel?.self, forKey: .campaign)
        products = try values.decode([ProductSearchModel]?.self, forKey: .products)
        errorString = ""
        instanceId = ""
        interactionId = ""
    }
    
    public  override init() {
        
    }
    
    public init(products: [ProductSearchModel], campaign:SearchCampaignModel?, errorString: String?, instanceId: String?, interactionId: String?) {
        self.campaign = campaign
        self.products = products
        self.errorString = errorString
        self.instanceId = instanceId
        self.interactionId = interactionId
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        var mProducts = [ProductSearchModel]()
        for p in products! {
            mProducts.append(p.copy() as! ProductSearchModel)
        }
        let copy = SearchModel(products: mProducts, campaign: campaign, errorString: errorString, instanceId: instanceId, interactionId: interactionId)
        return copy
    }
        
}
