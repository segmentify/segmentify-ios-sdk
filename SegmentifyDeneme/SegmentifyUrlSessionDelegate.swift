//
//  SegmentifyUrlSessionDelegate.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 12.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation
import UIKit

class SegmentifyUrlSessionDelegate : NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
}
