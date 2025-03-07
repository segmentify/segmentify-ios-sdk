//
//  FacetedFilter.swift
//  Segmentify
//

import Foundation

public class FacetedFilter{
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FacetedFilter(facet:facet, values:values)
        return copy
    }
    
    public var facet: String?
    public var values: [String]?
    
    public init(facet:String?, values:[String]?) {
        self.facet = facet
        self.values = values
    }
    
    var dictionary: [String: Any] {
        return ["facet": facet as Any,
                "values": values as Any]
    }
    public var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
