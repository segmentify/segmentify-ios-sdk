//
//  SegmentifyUrlSessionDelegate.swift
//  Segmentify


import Foundation
import UIKit

class SegmentifyUrlSessionDelegate : NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
}
