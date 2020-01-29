//
//  SearchCampaignModel.swift
//  Pods
//
//  Created by Ebru Goksal on 8.01.2020.
//

import Foundation

public class SearchCampaignModel : NSObject, Codable {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = SearchCampaignModel(instanceId :instanceId,name:name,accountId:accountId,status:status,devices:devices,searchDelay:searchDelay,minCharacterCount:minCharacterCount,searchUrlPrefix:searchUrlPrefix,searchInputSelector:searchInputSelector,hideCurrentSelector:hideCurrentSelector,desktopItemCount:desktopItemCount,mobileItemCount:mobileItemCount,searchAssets:searchAssets,stringSearchAssetTextMap: stringSearchAssetTextMap ,html:html,preJs:preJs,postJs:postJs,css:css,triggerSelector:triggerSelector,openingDirection:openingDirection)
        return copy
    }
    enum CodingKeys: String, CodingKey {
      case instanceId
      case name
      case accountId
      case status
      case devices
      case searchDelay
      case minCharacterCount
      case searchUrlPrefix
      case searchInputSelector
      case hideCurrentSelector
      case desktopItemCount
      case mobileItemCount
      case searchAssets
      case stringSearchAssetTextMap
      case html
      case preJs
      case postJs
      case css
    }
    public override init() {}
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        instanceId = try values.decode(String.self, forKey:  .instanceId)
        name = try values.decode(String.self, forKey:  .name)
        accountId = try values.decode(String.self, forKey:  .accountId)
        status = try values.decode(String.self, forKey:  .status)
        devices = try values.decode([String].self, forKey:  .devices)
        searchDelay = try values.decode(Int.self, forKey:  .searchDelay)
        minCharacterCount = try values.decode(Int.self, forKey:  .minCharacterCount)
        searchUrlPrefix = try values.decode(String.self, forKey:  .searchUrlPrefix)
        searchInputSelector = try values.decode(String.self, forKey:  .searchInputSelector)
        hideCurrentSelector = try values.decode(String.self, forKey:  .hideCurrentSelector)
        desktopItemCount = try values.decode(Int.self, forKey:  .desktopItemCount)
        mobileItemCount = try values.decode(Int.self, forKey:  .mobileItemCount)
        searchAssets = try values.decode([SearchAssetModel].self, forKey:  .searchAssets)
        stringSearchAssetTextMap = try values.decode([String:SearchAssetTextModel].self, forKey:  .stringSearchAssetTextMap)
        html = try values.decode(String.self, forKey:  .html)
        preJs = try values.decode(String.self, forKey:  .preJs)
        postJs = try values.decode(String.self, forKey:  .postJs)
        css = try values.decode(String.self, forKey:  .css)
    }
    
        var instanceId : String?
        var name:String?
        var accountId:String?
        var status:String?
        var devices:[String]?
        var searchDelay:Int?
        var minCharacterCount:Int?
        var searchUrlPrefix:String?
        var searchInputSelector:String?
        var hideCurrentSelector:String?
        var desktopItemCount:Int?
        var mobileItemCount:Int?
        var searchAssets = [SearchAssetModel]()
    var stringSearchAssetTextMap = [String:SearchAssetTextModel]()
        var html:String?
        var preJs:String?
        var postJs:String?
        var css:String?
        var triggerSelector:String?
        var openingDirection:String?
    
    public init(instanceId : String?,name:String?,accountId:String?,status:String?,devices:[String]?,searchDelay:Int?,minCharacterCount:Int?,searchUrlPrefix:String?,searchInputSelector:String?,hideCurrentSelector:String?,desktopItemCount:Int?,mobileItemCount:Int?,searchAssets:[SearchAssetModel],stringSearchAssetTextMap: [String:SearchAssetTextModel] ,html:String?,preJs:String?,postJs:String?,css:String?,triggerSelector:String?,openingDirection:String?) {
        self.instanceId = instanceId
        self.name = name
        self.accountId = accountId
        self.status = status
        self.devices = devices
        self.searchDelay = searchDelay
        self.minCharacterCount = minCharacterCount
        self.searchUrlPrefix = searchUrlPrefix
        self.searchInputSelector = searchInputSelector
        self.hideCurrentSelector = hideCurrentSelector
        self.desktopItemCount = desktopItemCount
        self.mobileItemCount = mobileItemCount
        self.searchAssets = searchAssets
        self.stringSearchAssetTextMap = stringSearchAssetTextMap
        self.html = html
        self.preJs = preJs
        self.postJs = postJs
        self.css = css
        self.triggerSelector = triggerSelector
        self.openingDirection = openingDirection
    }
}
