//
//  FacetedOrdering.swift
//  Segmentify

import Foundation

public class FacetedOrdering:NSObject {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FacetedOrdering(page:page, sort:sort)
        return copy
    }
    
    public override init() {
        page=1
        sort="SMART_SORTING"
    }
    public var page:Int?
    public var sort:String?
    
    public init(page:Int?, sort:String?) {
        self.page = page
        self.sort = sort
    }
    
    var dictionary: [String: Any] {
        return ["page": page as Any,
                "sort": sort as Any]
    }
    public var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
