//
//  Array.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 11.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import Foundation

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
