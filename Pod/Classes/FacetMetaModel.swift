//
//  FacetMetaModel.swift
//  Segmentify

import Foundation

public class FacetMetaModel : NSObject {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FacetMetaModel(total:total, page:page, params:params)
        return copy
    }
    
    public override init() {}
    
    var total:CLong?
    var page:FacetPageModel?
    var params:[String: AnyObject]?
    
    
    public init(total:CLong?, page:FacetPageModel?, params:[String: AnyObject]?) {
        self.total = total
        self.page = page
        self.params = params
    }
}
