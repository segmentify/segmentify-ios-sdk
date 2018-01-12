//
//  SegmentifyConnectionManager.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 8.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation

class SegmentifyConnectionManager : NSObject, URLSessionDelegate  {
    
    static let timeoutInterval = 30
    static let baseUrl = "/add/events/v1.json"
    
    static let sharedInstance : SegmentifyConnectionManager = {
        let shareManager = SegmentifyConnectionManager()
        return shareManager
    }()
    
    let sessionDelegate: SegmentifyUrlSessionDelegate
    var debugMode = true
    
    func shared() -> SegmentifyConnectionManager {
        return .sharedInstance
    }
    
    override init() {
        sessionDelegate = SegmentifyUrlSessionDelegate()
    }

    static var urlSession: URLSession {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpMaximumConnectionsPerHost = 3
        
        return URLSession.init(configuration: configuration, delegate: SegmentifyUrlSessionDelegate(), delegateQueue: nil)
        
    }
    
    func request(urlString: String) {
        let url = URL.init(string: urlString)
        let request = URLRequest.init(url: url!)
        debugPrint("Request to : \(url!)")
        let dataTask = SegmentifyConnectionManager.urlSession.dataTask(with: request) {data, response, error in
            debugPrint("Server responded. Error  : \(String(describing: error))")
        }
        dataTask.resume()
    }
    
    //func request<T : SegmentifyRequestProtocol>(requestModel : T, callback: @escaping (_ response : T?) -> Void) {
    func request<R: SegmentifyRequestProtocol>(requestModel: R, success: @escaping (_ response: [String:AnyObject]) -> Void, failure: @escaping (_ error: Error) -> Void) {

        //TODO prod = true olacak
        //var prod = false
        
        /*let emIsProd = SegmentifyTools.retrieveUserDefaults(userKey: "em_is_prod")
        if emIsProd != nil
        {
            prod = emIsProd as! Bool
         }*/
        
        var url: URL?
        //if (prod) {
            //TODO
            //test url gibi değişiklik olacak
            //url = URL.init(string: "https://\(requestModel.subdomain)\(SegmentifyConnectionManager.prodBaseUrl)/\(requestModel.path)")
        //}
        //else {
            //url = URL.init(string: "\(SegmentifyConnectionManager.testBaseUrl):\(requestModel.port)/\(requestModel.path)")
            url = URL.init(string: "\(requestModel.dataCenterUrl)\(SegmentifyConnectionManager.baseUrl)?apiKey=8157d334-f8c9-4656-a6a4-afc8b1846e4c")
        //}

        print("URL : \(String(describing: url!))")
        
        var request = URLRequest.init(url: url!)
        request.httpMethod = requestModel.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(requestModel.subdomain, forHTTPHeaderField: "Origin")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = TimeInterval(SegmentifyConnectionManager.timeoutInterval)
        print("request header : \(String(describing: (request.allHTTPHeaderFields)!))")
        
        if (requestModel.method == "POST" || requestModel.method == "PUT") {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestModel.toDictionary(), options: [])
        }
        
        if (request.httpBody != nil) {
            debugPrint("Request to \(url!) with body \(String.init(data: request.httpBody!, encoding: String.Encoding.utf8)!)")
        }
            
        let dataTask = SegmentifyConnectionManager.urlSession.dataTask(with: request) {data, response, connectionError in
            print("request : \(request)")
            if connectionError == nil {
                let remoteResponse = response as! HTTPURLResponse
                
                DispatchQueue.main.async {
                    if (connectionError == nil && (remoteResponse.statusCode == 200 || remoteResponse.statusCode == 201)) {
                        if (self.debugMode) {
                            print("Server response code : \(remoteResponse.statusCode)")
                        }
                        
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                            //print(jsonObject!["statusCode"])
                            
                            print("response : \(String(describing: jsonObject))")

                            /*let jsonObject = try JSONDecoder().decode([[SegModel]].self, from: data!)
                            print("responses : \(jsonObject)")*/
                            
                            /*for obj in jsonObject {
                                print("obj : \(obj)")
                            }*/
                            //dump(jsonObject.first?.type)
                            
                            
                            /*if (self.debugMode) {
                                print("Server response with success : \(String(describing: jsonObject))")
                            }*/
                            
                            
                            //success(jsonObject!["responses"] as AnyObject:String)
                            //success(jsonObject as AnyObject)
                            success(jsonObject!)
                            
                        } catch {
                            success(([String:AnyObject]() as AnyObject) as! [String : AnyObject])
                        }
                    }
                    else {
                        failure(connectionError!)
                        if (self.debugMode) {
                            print("Server response with failure : \(remoteResponse.statusCode)")
                            
                        }
                    }
                }
            } else {
                print("Connection error \(String(describing: connectionError))")
            }
        }
        dataTask.resume()
    }
    
    
}
