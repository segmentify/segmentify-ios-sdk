//
//  SegmentifyRequestProtocol.swift
//  SegmentifyIosDemo
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation

protocol SegmentifyRequestProtocol {
    
    var path: String { get }
    var port: String { get }
    var method: String { get }
    var subdomain: String { get }
    var dataCenterUrl: String { get }
    var apiKey: String { get }
    
    func toDictionary() -> Dictionary<AnyHashable, Any>
}
