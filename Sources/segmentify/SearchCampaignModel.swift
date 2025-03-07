//
//  SearchCampaignModel.swift
//  Segmentify

import Foundation

public class SearchCampaignModel : NSObject {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = SearchCampaignModel(instanceId :instanceId,name:name,status:status,devices:devices,searchDelay:searchDelay,minCharacterCount:minCharacterCount,searchUrlPrefix:searchUrlPrefix,mobileItemCount:mobileItemCount,stringSearchAssetTextMap: stringSearchAssetTextMap)
        return copy
    }
    public override init() {}
    
        var instanceId : String?
        var name:String?
        var status:String?
        var devices:[String]?
        var searchDelay:Int?
        var minCharacterCount:Int?
        var searchUrlPrefix:String?
        var mobileItemCount:Int?
        var stringSearchAssetTextMap = [String:SearchAssetTextModel]()
    
    
    public init(instanceId : String?,name:String?,status:String?,devices:[String]?,searchDelay:Int?,minCharacterCount:Int?,searchUrlPrefix:String?,mobileItemCount:Int?,stringSearchAssetTextMap: [String:SearchAssetTextModel] ) {
        self.instanceId = instanceId
        self.name = name
        self.status = status
        self.devices = devices
        self.searchDelay = searchDelay
        self.minCharacterCount = minCharacterCount
        self.searchUrlPrefix = searchUrlPrefix
        self.mobileItemCount = mobileItemCount
        self.stringSearchAssetTextMap = stringSearchAssetTextMap
    }
}
