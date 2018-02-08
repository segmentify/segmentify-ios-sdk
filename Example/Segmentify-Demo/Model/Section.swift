//
//  Section.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 8.02.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import Foundation
class Section {
    var sectionName: String?
    var sectionObjects: [Product]?
    
    init(sectionName: String?, sectionObjects: [Product]) {
        self.sectionName = sectionName
        self.sectionObjects = sectionObjects
    }
}
