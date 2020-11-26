//
//  BasketModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

@objc public class BasketModel: SegmentifyObject {
    @objc public override init() {}
    @objc public var step:String?
    @objc public var price:NSNumber?
    @objc public var quantity:NSNumber?
    @objc public var productId:String?
}
