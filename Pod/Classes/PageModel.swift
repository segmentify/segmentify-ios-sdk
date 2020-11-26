//
//  PageModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

public class PageModel:SegmentifyObject {
   public override init() {}
   @objc public var category:String?
   @objc public var subCategory:String?
   @objc public var recommendIds:[String]?
}
