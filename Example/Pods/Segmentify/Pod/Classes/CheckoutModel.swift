//
//  CheckoutModel.swift
//  Segmentify

import Foundation

public class CheckoutModel : SegmentifyObject {
    public override init() {}
    public var totalPrice:NSNumber?
    public var productList:[Any]?
    public var orderNo:String?
}
