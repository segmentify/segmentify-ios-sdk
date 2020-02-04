//
//  SearchCampaignModel.swift
//  Pods
//
//  Created by Ebru Goksal on 8.01.2020.
//

import Foundation

public class SearchCampaignModel : NSObject {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = SearchCampaignModel(instanceId :instanceId,name:name,accountId:accountId,status:status,devices:devices,searchDelay:searchDelay,minCharacterCount:minCharacterCount,searchUrlPrefix:searchUrlPrefix,searchInputSelector:searchInputSelector,hideCurrentSelector:hideCurrentSelector,desktopItemCount:desktopItemCount,mobileItemCount:mobileItemCount,searchAssets:searchAssets,stringSearchAssetTextMap: stringSearchAssetTextMap ,html:html,preJs:preJs,postJs:postJs,css:css,triggerSelector:triggerSelector,openingDirection:openingDirection)
        return copy
    }
    public override init() {}
    
    
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
