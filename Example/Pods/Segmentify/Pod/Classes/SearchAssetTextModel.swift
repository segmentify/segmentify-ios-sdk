//
//  SearchAssetTextModel.swift
//  Segmentify
//
//  Created by Ebru Goksal on 9.01.2020.
//

import Foundation

public class SearchAssetTextModel:  NSObject, Codable {
    var popularCategoriesText:String = ""
    var popularBrandsText:String = ""
    var popularKeywordsText:String = ""
    var popularProductsText:String = ""
    var categoriesText:String = ""
    var brandsText:String = ""
    var mobileCancelText:String = ""
    var notFoundText:String = ""
    enum CodingKeys: String, CodingKey {
        case popularCategoriesText
        case popularBrandsText
        case popularKeywordsText
        case popularProductsText
        case categoriesText
        case  brandsText
        case mobileCancelText
        case notFoundText
    }
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        popularCategoriesText = try values.decode(String.self, forKey:  .popularCategoriesText)
        popularBrandsText = try values.decode(String.self, forKey:  .popularBrandsText)
        popularKeywordsText = try values.decode(String.self, forKey:  .popularKeywordsText)
        popularProductsText = try values.decode(String.self, forKey:  .popularProductsText)
        categoriesText = try values.decode(String.self, forKey:  .categoriesText)
        brandsText = try values.decode(String.self, forKey:  .brandsText)
        mobileCancelText = try values.decode(String.self, forKey:  .mobileCancelText)
        notFoundText = try values.decode(String.self, forKey:  .notFoundText)
    }
    
    public override init() {
        
    }
}
