//
//  SearchFacetPageModel.swift
//  Segmentify

import Foundation

public class SearchFacetPageModel:SegmentifyObject {
    public override init() {}
    public var query:String?
    public var type:String?
    public var ordering:FacetedOrdering?
    public var trigger:String?
}
