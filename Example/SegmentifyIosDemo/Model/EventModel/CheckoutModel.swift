//
//  CheckoutCustomerInformationModel.swift
//  SegmentifyIosDemo
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import Foundation

class CheckoutModel : SegmentifyObject {
    var step:String?
    var totalPrice:NSNumber?
    var productList:[Any]?
    var orderNo:String?
}
