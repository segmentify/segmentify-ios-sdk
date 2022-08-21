//
//  Facets.swift
//  Segmentify

import Foundation

public class Facet : NSObject {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Facet(property:property, items:items, filtered:filtered, viewMode: viewMode)
        return copy
    }
    
    public override init() {}
        var property : String?
        var items:[FacetItem]?
        var filtered:String?
        var viewMode:FacetViewMode?
    
    
    public init(property:String?, items:[FacetItem]?, filtered:String?, viewMode:FacetViewMode?) {
        self.property = property
        self.items = items
        self.filtered = filtered
        self.viewMode = viewMode
    }
}
