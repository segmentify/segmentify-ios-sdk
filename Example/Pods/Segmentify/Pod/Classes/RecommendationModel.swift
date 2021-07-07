//
//  RecommendationModel.swift
//  Segmentify

import Foundation

public class RecommendationModel : NSObject,NSCopying {
    public var notificationTitle:String?
    public var products:[ProductRecommendationModel]?
    public var errorString:String?
    public var instanceId:String?
    public var interactionId:String?
    
    public  override init() {
        
    }
    
    public init(notificationTitle: String, products: [ProductRecommendationModel], errorString: String?, instanceId: String?, interactionId: String?) {
        self.notificationTitle = notificationTitle
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
        let copy = RecommendationModel(notificationTitle: notificationTitle!, products: mProducts, errorString: errorString, instanceId: instanceId, interactionId: interactionId)
        return copy
    }
    
    
}

