//
//  RecommendationModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 22.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

@objc public class RecommendationModel : NSObject,NSCopying {
    public var notificationTitle:String?
    @objc public var products:[ProductRecommendationModel]?
    public var errorString:String?
    @objc public var instanceId:String?
    @objc public var interactionId:String?
    
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

