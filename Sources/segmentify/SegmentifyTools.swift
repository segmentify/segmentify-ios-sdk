//
//  SegmentifyTools.swift
//  Segmentify

import Foundation

class SegmentifyTools:NSObject {
    
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    static func validateEmail(email: String?) -> Bool {
        guard email != nil else {
            return false
        }
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return (emailTest.evaluate(with: email!))
    }
    
    static func retrieveUserDefaults(userKey: String) -> AnyObject? {
        guard let value = UserDefaults.standard.object(forKey: userKey) else {
            return nil
        }
        return value as AnyObject?
    }
    
    static func removeUserDefaults(userKey: String) -> Void {
        if (UserDefaults.standard.object(forKey: userKey) != nil) {
            UserDefaults.standard.removeObject(forKey: userKey)
        }
    }
    
    static func saveUserDefaults(key: String?, value: AnyObject?) -> Void {
        guard (key != nil && value != nil) else {
            return
        }
        UserDefaults.standard.set(value, forKey: key!)
        UserDefaults.standard.synchronize()
    }
    
    static func getInfoString(key: String) -> String {
        let bundle = Bundle.init(for: self)
        return bundle.infoDictionary![key] as! String
    }
    
    static func convertJsonStringToDictionary(text: String) -> [AnyHashable: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func convertDictionaryToJsonString(dictionary: [AnyHashable: Any]) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func convertStringToDictionary(text: String) -> [[String:AnyObject]]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:AnyObject]]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            // your function here
            closure()
        })
    }
}
