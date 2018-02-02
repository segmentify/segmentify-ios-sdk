//
//  SegmentifyUrlSessionDelegate.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 22.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//


import Foundation
import UIKit

class SegmentifyUrlSessionDelegate : NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
}
