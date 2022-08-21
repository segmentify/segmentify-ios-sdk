//
//  SearchBannerModel.swift
//  Segmentify

import Foundation

public class SearchBannerModel:NSObject {
    public override init() {}
    public var id:String?
    public var instanceId:String?
    public var status:SearchBannerStatus?
    public var searchType:SearchType?
    public var name: String?
    public var bannerUrl:String?
    public var targetUrl:String?
    public var position:SearchBannerPositionType?
    public var width:String?
    public var height:String?
}
