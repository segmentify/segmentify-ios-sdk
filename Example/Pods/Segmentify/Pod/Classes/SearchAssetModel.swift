//
//  SearchAssetModel.swift
//  Pods
//
//  Created by Ebru Goksal on 8.01.2020.
//

import Foundation

public class SearchAssetModel: NSObject, Codable {
    var assetType : AssetType?
    var itemCount : Int?
    var clickable : Bool?
    var categoryTreeView : Bool?
    
    enum CodingKeys: String, CodingKey {
      case assetType
      case itemCount
      case clickable
      case categoryTreeView
    }
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        assetType = try values.decode(AssetType.self, forKey:  .assetType)
        itemCount = try values.decode(Int.self, forKey:  .itemCount)
        clickable = try values.decode(Bool.self, forKey:  .clickable)
        categoryTreeView = try values.decode(Bool.self, forKey:  .categoryTreeView)
    }
    
    public  override init() { 
        
    }
    
}
