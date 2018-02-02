//
//  CheckoutModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

public class CheckoutModel : SegmentifyObject {
    public override init() {}
    public var totalPrice:NSNumber?
    public var productList:[Any]?
    public var orderNo:String?
}
