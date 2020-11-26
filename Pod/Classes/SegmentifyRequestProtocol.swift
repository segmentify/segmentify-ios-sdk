//
//  SegmentifyRequestProtocol.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 22.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
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
