//
//  FacetItem.swift
//  Segmentify

import Foundation

public class FacetItem : NSObject {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FacetItem(value:value, count:count)
        return copy
    }
    public override init() {}
    
    var value:String?
    var count:CLong?
    
    public init(value : String?,count:CLong? ) {
        self.value = value
        self.count = count
    }
}
