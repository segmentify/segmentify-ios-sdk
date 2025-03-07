//
//  ProductModel.swift
//  Segmentify

import Foundation

public class UtmModel{

    public var utm_source:String?
    public var utm_medium:String?
    public var utm_campaign:String?
    public var utm_content:String?

    public  init() {

        self.utm_source = "segmentify"
        self.utm_medium = "push"

        let instanceId = UserDefaults.standard.object(forKey: "SEGMENTIFY_PUSH_CAMPAIGN_ID") as? String
        let productId = UserDefaults.standard.object(forKey: "SEGMENTIFY_PUSH_CAMPAIGN_PRODUCT_ID") as? String

        if (instanceId?.isEmpty == false) {
            self.utm_campaign = instanceId
        }
        if (productId?.isEmpty == false) {
            self.utm_content = productId
        }
        
    }
}

