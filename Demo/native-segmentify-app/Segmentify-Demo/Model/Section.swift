//
//  Section.swift
//  Segmentify-Demo

import Foundation
// for HomeViewController sections
class Section {
    var sectionName: String?
    var sectionObjects: [Product]?
    
    init(sectionName: String?, sectionObjects: [Product]) {
        self.sectionName = sectionName
        self.sectionObjects = sectionObjects
    }
}
