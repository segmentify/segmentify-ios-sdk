//
//  UserTraits.swift
//  Segmentify

import Foundation

public class UserTraitsModel:SegmentifyObject {
    public override init() {}
    public var properties: [String: Any] = [:]

    public convenience init(properties: [String: Any]) {
        self.init()
        self.properties = properties
    }
}
