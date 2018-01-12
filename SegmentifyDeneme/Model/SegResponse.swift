//
//  SegResponse.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 5.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import Foundation

struct SegModel : Codable {
    
    var campaigns:String
    var responses:Responses
    
    struct Responses : Codable {
        
        var type:String
        var params:Params
        
        struct Params : Codable {
            var notificationTitle:String
            var recommendedProducts:RecommendedProducts
            
            struct RecommendedProducts : Codable {
                var productId:String
                var name:String
                var price:Int
            }
        }
    }
}






