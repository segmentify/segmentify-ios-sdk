//
//  FacetPageModel.swift
//  Segmentify

import Foundation

public class FacetPageModel : NSObject {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FacetPageModel(current:current, rows:rows, prev:prev, next:next)
        return copy
    }
    public override init() {}
    
    var current:Int?
    var rows:Int?
    var prev:Bool?
    var next:Bool?
    
    public init(current:Int?,rows:Int?, prev:Bool?, next:Bool?) {
        self.current = current
        self.rows = rows
        self.prev = prev
        self.next = next
    }
}
