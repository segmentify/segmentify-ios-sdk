//
//  CheckoutModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

@objc public class CheckoutModel : SegmentifyObject {
    @objc public override init() {}
    @objc public var totalPrice:NSNumber?
    @objc public var productList:[Any]?
    @objc public var orderNo:String?
}
