//
//  SegmentifyManager.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation

protocol SegmentifyManagerDelegate {
    func segmentifyCallback(recommendation : RecommendationModel)
}

class SegmentifyManager {
    private var delegate : SegmentifyManagerDelegate?
    static let sdkVersion = "1.0"
    
    static let tokenKey = "SEGMENTIFY_TOKEN_KEY"
    static let registerKey = "SEGMENTIFY_REGISTER_KEY"
    static let lastRequestDateKey = "SEGMENTIFY_LAST_REQUEST_DATE_KEY"
 
    static let pageViewEventName = "PAGE_VIEW"
    static let productViewEventName = "PRODUCT_VIEW"
    static let basketOperationsEventName = "BASKET_OPERATIONS"
    static let checkoutEventName = "CHECKOUT"
    static let userOperationEventName = "USER_OPERATIONS"
    static let userChangeEventName = "USER_CHANGE"
    static let customEventName = "CUSTOM_EVENT"
    static let interactionEventName = "INTERACTION"
    
    
    static let customerInformationStep = "customer"
    static let viewBasketStep = "view-basket"
    static let paymentInformationStep = "payment"
    static let paymentPurchaseStep = "purchase"
    static let paymentSuccessStep = "success"
    static let signInStep = "signin"
    static let registerStep = "signup"
    static let logoutStep = "signout"
    static let updateUserStep = "update"
    static let impressionStep = "impression"
    static let widgetViewStep = "widget_view"
    static let clickStep = "click"
    
    static let startIndex = 0
    
    private var instanceId:String?
    private var interactionId:String?
    private var params : Dictionary<AnyHashable, Any>?
    private var paramsArr : [[AnyHashable:Any]]?
    private var validStaticItem : Bool = false
    private var staticItems : [AnyHashable : Any]?
    private var recommendationSourceKeys : [String] = []
    private var timeFrameKeys : [String] = []
    private var keys : [String] = []
    private var itemCounts : [String] = []
    private var dynamicItemsArray : [DynamicItemsModel] = []
    private var recommendationArray = [AnyHashable : Any]()
    private var recommendations :[RecommendationModel] = []
    private var staticItemsRecommendationarray : [ProductModel] = []
    //private var testStaticItems : [ProductModel] = []
    private var currentKey : String?
    private var staticItemsArrayCount : Int = Int()
    private var currentNewArray : [RecommendationModel]?
    
    private var newRecommendationArray : [RecommendationModel] = []
    
    private var testStaticProducts : [AnyHashable:Any]?
    private var testOtherProducts : [AnyHashable:Any]?

    private var currentRecModel = RecommendationModel()
    private var products : [ProductModel] = []
    private static var segmentifySharedInstance: SegmentifyManager?
    private var eventRequest = SegmentifyRegisterRequest()
    //let recModel = RecommendationModel()
    
    class func sharedManager(appKey: String, dataCenterUrl: String, subDomain: String) -> SegmentifyManager {
        if segmentifySharedInstance == nil {
            segmentifySharedInstance = SegmentifyManager.init(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain)
        }
        return segmentifySharedInstance!
    }
    
    var debugMode = false {
        didSet {
            SegmentifyConnectionManager.sharedInstance.debugMode = debugMode
        }
    }
    
    init(appKey: String, dataCenterUrl: String, subDomain: String) {

        eventRequest.appKey = appKey
        eventRequest.subdomain = subDomain
        eventRequest.dataCenterUrl = dataCenterUrl
        eventRequest.sdkVersion = SegmentifyManager.sdkVersion
        eventRequest.token = SegmentifyTools.retrieveUserDefaults(userKey: SegmentifyManager.tokenKey) as? String
        
        /*if UserDefaults.standard.object(forKey: Constant.IS_USER_SENT_USER_ID) != nil {
            UserDefaults.standard.removeObject(forKey:  Constant.IS_USER_SENT_USER_ID)
        }*/
        
        if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
        }
        /*if UserDefaults.standard.object(forKey: Constant.IS_USER_LOGIN) != nil {
            eventRequest.oldUserId = UserDefaults.standard.object(forKey: "LAST_GENERATED_FROM_SEGMENTIFY_USER_ID") as? String
        }*/
        
        if let lastRegister = SegmentifyTools.retrieveUserDefaults(userKey: SegmentifyManager.registerKey) {
            let lastRequest = SegmentifyRegisterRequest.init(withJsonString: lastRegister as! String)
            eventRequest.extra = (lastRequest?.extra)!
        }
        
        self.currentKey = "RECOMMENDATION_SOURCE_STATIC_ITEMS"
    }

    // MARK: Request Builders
    func setIDAndSendEvent() {
        self.getUserIdAndSessionIdRequest( success: { () -> Void in
            self.sendEvent(callback: { (response: [RecommendationModel]) in
                //self.testFunc()
            })
        })
    }
    
    func setIDAndSendEventWithCallback(callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        self.getUserIdAndSessionIdRequest( success: { () -> Void in
            self.sendEvent(callback: { (response: [RecommendationModel]) in
                callback(response)
            })
        })
    }
    
    func sendEvent(callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        SegmentifyConnectionManager.sharedInstance.request(requestModel: eventRequest, success: {(response: [String:AnyObject]) in

            guard let responses = response["responses"] as? [[Dictionary<AnyHashable,Any>]] else {
                print("error : \(response["statusCode"]! as Any)")
                return
            }
            
            //for (index,obj) in responses.enumerated() {
            for (index, obj) in responses[0].enumerated() {
                guard let params = obj["params"] as? Dictionary<AnyHashable, Any> else {
                    return
                }
                self.params = params
                //print("params = \(params)")
                
                guard let dynamicItems = self.params!["dynamicItems"] as? String else {
                    print("params['dynamicItems'] is not valid")
                    return
                }
                
                guard let dynamicDic = self.convertStringToDictionary(text: dynamicItems) else {
                    print("cannot converted string to json")
                    return
                }
                
                guard let recommendedProducts = self.params!["recommendedProducts"] as? Dictionary<AnyHashable, Any> else {
                    print("params['recommendedProducts'] is not valid")
                    return
                }
                self.recommendationArray = recommendedProducts
                
                guard let notificationTitle = self.params!["notificationTitle"] as? String else {
                    print("params['notificationTitle'] is not valid")
                    return
                }
                
                guard let staticItems = self.params!["staticItems"] as? String else {
                    print("params['dynamicItems'] is not valid")
                    return
                }
                
                guard let staticItemsDic = self.convertStringToDictionary(text: staticItems) else {
                    print("cannot converted string to json")
                    return
                }
                
                if staticItemsDic.count > 0 {
                    self.validStaticItem = true
                }
                
                
                    self.instanceId = String()
                    if let instanceId = self.params!["instanceId"] as? String {
                        self.instanceId = instanceId
                    }
                    self.interactionId = String()
                    if let interactionId = self.params!["actionId"] as? String {
                        self.interactionId = interactionId
                    }
                    
                    if self.instanceId != nil && self.interactionId != nil {
                        self.setImpressionEvent(instanceId: self.instanceId!, interactionId: self.interactionId!)
                    }

                
                for object in dynamicDic {
                    let dynObj = DynamicItemsModel()
                    if let recoomendationSource = object["recommendationSource"] {
                        self.recommendationSourceKeys.append(recoomendationSource as! String)
                        dynObj.recommendationSource = recoomendationSource as? String
                    }
                    if let timeFrameKey = object["timeFrame"] {
                        self.timeFrameKeys.append(timeFrameKey as! String)
                        dynObj.timeFrame = timeFrameKey as? String
                    }
                    if let itemCount = object["itemCount"] {
                        self.itemCounts.append(itemCount as! String)
                        dynObj.itemCount = Int(itemCount as! String)
                    }
                    let key = "\(object["recommendationSource"]!)|\(object["timeFrame"]!)"
                    dynObj.key = key
                    self.keys.append(key)
                    self.dynamicItemsArray.append(dynObj)
                }
                
                self.getStaticItemsArray(notificationTitle: notificationTitle, recommendedProducts: recommendedProducts, staticItems: nil)
                
                self.getRecommendations(notificationTitle: notificationTitle, recommendedProducts: recommendedProducts, staticItems: nil, keys: self.keys)
            }
      

            callback(self.recommendations)
            
        }, failure: {(error: Error) in
            if (self.debugMode) {
                print("Request failed : \(error)")
            }
            let errorRecModel = RecommendationModel()
            errorRecModel.errorString = "error"
            callback(self.recommendations)
        })
    }
    
    private func getStaticItemsArray(notificationTitle: String, recommendedProducts: Dictionary<AnyHashable, Any>, staticItems: Dictionary<AnyHashable, Any>?) {

        self.currentKey = "RECOMMENDATION_SOURCE_STATIC_ITEMS"
        if dynamicItemsArray.count > 0 {
            for dynObj in dynamicItemsArray {
                if let products = recommendedProducts[self.currentKey!] as? [[AnyHashable:Any]] {
                    if products.count > 0 {
                        
                        self.createRecomendation(title: notificationTitle, itemCount: dynObj.itemCount!, products: products)
                        self.staticItemsArrayCount = (self.currentRecModel.products?.count)!
                    }
                }
            }
        }
    }
    
    private func getRecommendations(notificationTitle: String, recommendedProducts: Dictionary<AnyHashable, Any>, staticItems: Dictionary<AnyHashable, Any>?,  keys : [String]) {
        if validStaticItem {
            self.recommendationArray["products"] = staticItems as AnyObject
        }
        var newProdArray = [ProductModel]()

        if dynamicItemsArray.count > 0 {
            for dynObj in dynamicItemsArray {
                
                self.currentKey = dynObj.key
                if let products = recommendedProducts[dynObj.key!] as? [[AnyHashable:Any]] {
                    if products.count > 0 {
                        
                        
                        self.createRecomendation(title: notificationTitle, itemCount: dynObj.itemCount!, products: products)
                        

                        for product in currentRecModel.products!{
                            if newProdArray.contains(where: {$0.productId==product.productId}){ }
                            else{
                                newProdArray.append(product)
                            }
                            
                        }

                    
                        self.products.removeAll()
                        
                        currentRecModel = RecommendationModel()
                    }
                }
            }
            
            
            
            
            var newRecModel = RecommendationModel()
            newRecModel.notificationTitle = notificationTitle
            newRecModel.products = newProdArray
            recommendations.append(newRecModel)
            
            
            //print(recommendations)
        

        }
    }
    
    private func createRecomendation(title:String, itemCount:Int, products:[[AnyHashable:Any]]) {
        var staticProducts = [ProductModel]()
        if !self.products.isEmpty {
            for staticProduct in self.products{
                staticProducts.append(staticProduct.copy() as! ProductModel)
            }
        }
        
        for (index, obj) in products.enumerated() {

            let proObj = ProductModel()
            if let brand = obj["brand"] {
                proObj.brand = brand as? String
            }
            if let name = obj["name"] {
                proObj.name = name as? String
            }
            if let productId = obj["productId"] {
                proObj.productId = productId as? String
            }
            if let currency = obj["currency"] {
                proObj.currency = currency as? String
            }
            if let image = obj["image"] {
                proObj.image = image as? String
            }
            if let inStock = obj["inStock"] {
                proObj.inStock = inStock as? Bool
            }
            if let insertTime = obj["insertTime"] {
                proObj.insertTime = insertTime as? Int
            }
            if let language = obj["language"] {
                proObj.language = language as? String
            }
            if let price = obj["price"] {
                proObj.price = price as? Int
            }
            if let priceText = obj["priceText"] {
                proObj.priceText = priceText as? String
            }
            if let oldPriceText = obj["oldPriceText"] {
                proObj.oldPriceText = oldPriceText as? String
            }
            if let lastUpdateTime = obj["lastUpdateTime"] {
                proObj.lastUpdateTime = lastUpdateTime as? Int
            }

            if index == (self.validStaticItem ? (itemCount - 1) + self.staticItemsArrayCount : itemCount) {
                break
            }
  
            if self.products.contains(where: {$0.productId == proObj.productId}) {
                
            } else {
                if !staticProducts.isEmpty{
                    var flag = true
                    for staticProduct in staticProducts{
                        if staticProduct.productId == proObj.productId{
                            flag = false
                            break
                        }
                    }
                    if flag{
                        self.products.append(proObj)
                    }
                }else{
                    self.products.append(proObj)
                }
                self.currentRecModel.products = self.products
            }
        }
        
        self.currentRecModel.notificationTitle = title
    }
    
    //EVENTS
    //Register Event
    func userRegister(segmentifyObject : SegmentifyObject) {
        
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.registerStep
        eventRequest.username = segmentifyObject.username
        
        if let fullName = segmentifyObject.fullName {
            eventRequest.fullName = fullName
        }
        if let email = segmentifyObject.email {
            eventRequest.email = email
        }
        if let mobilePhone = segmentifyObject.mobilePhone {
            eventRequest.mobilePhone = mobilePhone
        }
        if let gender = segmentifyObject.gender {
            eventRequest.gender = gender
        }
        if let age = segmentifyObject.age {
            eventRequest.age = age
        }
        if let birthdate = segmentifyObject.birthdate {
            eventRequest.birthdate = birthdate
        }
        if let memberSince = segmentifyObject.memberSince {
            eventRequest.memberSince = memberSince
        }
        if let location = segmentifyObject.location {
            eventRequest.location = location
        }
        if let segments = segmentifyObject.segments {
            eventRequest.segments = segments
        }
        setIDAndSendEvent()
    }
    
    //Login Event
    func userLogin(segmentifyObject : SegmentifyObject) {
      
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.signInStep
        eventRequest.username = segmentifyObject.username!

        if segmentifyObject.userID != nil {
            UserDefaults.standard.set(Constant.IS_USER_SENT_USER_ID, forKey: Constant.IS_USER_SENT_USER_ID)
            UserDefaults.standard.set(segmentifyObject.userID, forKey: "UserSentUserId")
        }
        setIDAndSendEvent()
    }
    
    //Logout Event
    func userLogout(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.logoutStep
        eventRequest.username = segmentifyObject.username
        //eventRequest.userID = segmentifyObject.userID
        setIDAndSendEvent()
    }
    
    //User Update Event
    func userUpdate(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.updateUserStep
        eventRequest.username = segmentifyObject.username
        
        if let fullName = segmentifyObject.fullName {
            eventRequest.fullName = fullName
        }
        if let email = segmentifyObject.email {
            eventRequest.email = email
        }
        if let mobilePhone = segmentifyObject.mobilePhone {
            eventRequest.mobilePhone = mobilePhone
        }
        if let gender = segmentifyObject.gender {
            eventRequest.gender = gender
        }
        if let age = segmentifyObject.age {
            eventRequest.age = age
        }
        if let birthdate = segmentifyObject.birthdate {
            eventRequest.birthdate = birthdate
        }
        if let isRegistered = segmentifyObject.isRegistered {
            eventRequest.isRegistered = isRegistered
        }
        if let isLogin = segmentifyObject.isLogin {
            eventRequest.isLogin = isLogin
        }
        if let location = segmentifyObject.location {
            eventRequest.location = location
        }
        if let segments = segmentifyObject.segments {
            eventRequest.segments = segments
        }
        setIDAndSendEvent()
    }
    
    //Change User Event
    func setChangeUserEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.userChangeEventName
        eventRequest.userID = segmentifyObject.userID
        if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
            eventRequest.oldUserId = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
        }
        setIDAndSendEvent()
    }
    
    //Checkout Success Event
    func setPaymentSuccessEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.paymentSuccessStep
        eventRequest.totalPrice = segmentifyObject.totalPrice
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        if let basketID = segmentifyObject.basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = segmentifyObject.orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = segmentifyObject.products {
            eventRequest.products = products
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        setIDAndSendEvent()
    }
    
    //Checkout Purchase Event
    func setPurchaseEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.paymentPurchaseStep
        eventRequest.totalPrice = segmentifyObject.totalPrice
        
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        if let orderNo = segmentifyObject.orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = segmentifyObject.products {
            eventRequest.products = products
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }

        setIDAndSendEvent()
    }
    
    //Checkout Payment Event
    func setPaymentInformationEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = segmentifyObject.totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentInformationStep
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        if let basketID = segmentifyObject.basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = segmentifyObject.orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = segmentifyObject.products {
            eventRequest.products = products
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        setIDAndSendEvent()
    }
    
    //Checkout Customer Information Event
    func setCustomerInformationEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = segmentifyObject.totalPrice
        eventRequest.checkoutStep = SegmentifyManager.customerInformationStep
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        if let basketID = segmentifyObject.basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = segmentifyObject.orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = segmentifyObject.products {
            eventRequest.products = products
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        setIDAndSendEvent()
    }
    
    //Checkout View Basket Event
    func setViewBasketEvent(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = segmentifyObject.totalPrice
        eventRequest.checkoutStep = SegmentifyManager.viewBasketStep
        eventRequest.userID = segmentifyObject.userID
        
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        
        if let products = segmentifyObject.products {
            eventRequest.products = products
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        //setIDAndSendEvent()
        setIDAndSendEventWithCallback(callback: callback)

        //callback(self.recModel!)
    }
    
    //Add or Remove Basket Event
    func setAddOrRemoveBasketStepEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.basketOperationsEventName
        eventRequest.basketStep = segmentifyObject.basketStep
        eventRequest.productID = segmentifyObject.productID
        if let price = segmentifyObject.price {
            eventRequest.price = price
        }
        if let quantity = segmentifyObject.quantity {
            eventRequest.quantity = quantity
        }
        setIDAndSendEvent()
    }
    
    //Product View Event
    func setProductViewEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.productViewEventName
        eventRequest.productID = segmentifyObject.productID
        eventRequest.title = segmentifyObject.title
        eventRequest.price = segmentifyObject.price
        eventRequest.categories = segmentifyObject.categories
        eventRequest.image = segmentifyObject.image
        eventRequest.url = segmentifyObject.url
        if let brand = segmentifyObject.brand {
            eventRequest.brand = brand
        }
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        if let stock = segmentifyObject.stock {
            eventRequest.stock = stock
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        if let imageXS = segmentifyObject.imageXS {
            eventRequest.imageXS = imageXS
        }
        if let imageS = segmentifyObject.imageS {
            eventRequest.imageS = imageS
        }
        if let imageL = segmentifyObject.imageL {
            eventRequest.imageL = imageL
        }
        if let imageXL = segmentifyObject.imageXL {
            eventRequest.imageXL = imageXL
        }
        if let colors = segmentifyObject.colors {
            eventRequest.colors = colors
        }
        if let sizes = segmentifyObject.sizes {
            eventRequest.sizes = sizes
        }
        if let labels = segmentifyObject.labels {
            eventRequest.labels = labels
        }
        setIDAndSendEvent()
    }
    
    //Page View Event
    func setPageViewEvent(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        
        eventRequest.eventName = SegmentifyManager.pageViewEventName
        eventRequest.category = segmentifyObject.category
        
        if let subCategory = segmentifyObject.subCategory {
            eventRequest.subCategory = subCategory
        }
        if let pageUrl = segmentifyObject.pageUrl {
            eventRequest.pageUrl = pageUrl
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        if let categories = segmentifyObject.categories {
            eventRequest.categories = categories
        }
        //setIDAndSendEvent()
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Custom Event
    func setCustomEvent(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.customEventName
        eventRequest.type = segmentifyObject.type
        if let params = segmentifyObject.params {
            eventRequest.params = params
        }
        setIDAndSendEvent()
    }
   
     
     //Register Event
     func setRegisterEvent(username : String, fullName : String?, email : String?, mobilePhone : String?, gender : String?, age : String?, birthdate : String?) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.updateUserStep
         eventRequest.username = username
     
         if let fullName = fullName {
             eventRequest.fullName = fullName
         }
         if let email = email {
             eventRequest.email = email
         }
         if let mobilePhone = mobilePhone {
             eventRequest.mobilePhone = mobilePhone
         }
         if let gender = gender {
             eventRequest.gender = gender
         }
         if let age = age {
             eventRequest.age = age
         }
         if let birthdate = birthdate {
             eventRequest.birthdate = birthdate
         }
        
         /*if let isRegistered = isRegistered {
             eventRequest.isRegistered = isRegistered
         }
         if let isLogin = isLogin {
             eventRequest.isLogin = isLogin
         }*/
         setIDAndSendEvent()
     }
     
     //Login Event
     func setLoginEvent(username: String, userId: String) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.signInStep
         eventRequest.username = username
         eventRequest.userID = userId
         setIDAndSendEvent()
     }
     
     //Logout Event
     func setLogoutEvent(username: String) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.signInStep
         eventRequest.username = username
         setIDAndSendEvent()
     }
     
    //User Update Event
    func setUserUpdateEvent(username : String, fullName : String?, email : String?, mobilePhone : String?, gender : String?, age : String?, birthdate : String?, isRegistered : Bool?, isLogin : Bool?) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.updateUserStep
        eventRequest.username = username
        
        if let fullName = fullName {
            eventRequest.fullName = fullName
        }
        if let email = email {
            eventRequest.email = email
        }
        if let mobilePhone = mobilePhone {
            eventRequest.mobilePhone = mobilePhone
        }
        if let gender = gender {
            eventRequest.gender = gender
        }
        if let age = age {
            eventRequest.age = age
        }
        if let birthdate = birthdate {
            eventRequest.birthdate = birthdate
        }
        if let isRegistered = isRegistered {
            eventRequest.isRegistered = isRegistered
        }
        if let isLogin = isLogin {
            eventRequest.isLogin = isLogin
        }
        setIDAndSendEvent()
    }
    
    //Checkout Success Event
    func setPaymentSuccessEvent(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentSuccessStep
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let basketID = basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = products {
            eventRequest.products = products
        }
        setIDAndSendEvent()
    }
    
    //Checkout Purchase Event
    func setPurchaseEvent(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentPurchaseStep
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let basketID = basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = products {
            eventRequest.products = products
        }
       setIDAndSendEvent()
    }
    
    //Checkout Payment Event
    func setPaymentInformationEvent(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentInformationStep
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let basketID = basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = products {
            eventRequest.products = products
        }
        setIDAndSendEvent()
    }
    
    //Checkout Customer Information Event
    func setCustomerInformationEvent(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.customerInformationStep
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let basketID = basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = products {
            eventRequest.products = products
        }
        setIDAndSendEvent()
    }
    
    //Checkout View Basket Event
    func setViewBasketEvent(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.viewBasketStep
        
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let basketID = basketID {
            eventRequest.basketID = basketID
        }
        if let orderNo = orderNo {
            eventRequest.orderNo = orderNo
        }
        if let products = products {
            eventRequest.products = products
        }
        setIDAndSendEvent()
    }
    
    //Add or Remove Basket Event
    func setAddOrRemoveBasketStepEvent(basketStep : String, productID : String, price : NSNumber?, quantity : NSNumber?) {
        eventRequest.eventName = SegmentifyManager.basketOperationsEventName
        eventRequest.basketStep = basketStep
        eventRequest.productID = productID
        if let price = price {
            eventRequest.price = price
        }
        if let quantity = quantity {
            eventRequest.quantity = quantity
        }
        setIDAndSendEvent()
    }
    
    //Product View Event
    func setProductViewEvent(productID : String, title : String, category : [String], price : NSNumber, brand : String?, currency : String?, stock : Bool?, url: String, image : String ) {
        eventRequest.eventName = SegmentifyManager.productViewEventName
        eventRequest.productID = productID
        eventRequest.title = title
        eventRequest.price = price
        eventRequest.categories = category
        eventRequest.image = image
        eventRequest.url = url
        
        if let brand = brand {
            eventRequest.brand = brand
        }
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let stock = stock {
            eventRequest.stock = stock
        }
        setIDAndSendEvent()
    }

    //Page View Event
    func setPageViewEvent(category : String, subCategory : String?, pageUrl : String?) {
        eventRequest.eventName = SegmentifyManager.pageViewEventName
        eventRequest.category = category
        if let subCategory = subCategory {
            eventRequest.subCategory = subCategory
        }
        if let pageUrl = pageUrl {
            eventRequest.pageUrl = pageUrl
        }
        setIDAndSendEvent()
    }
    
    //TODO custom event
    
    func setCustomEvent(params : AnyObject?, type : String) {
        eventRequest.eventName = SegmentifyManager.customEventName
        eventRequest.type = type
        if let params = params {
            eventRequest.params = params
        }
        setIDAndSendEvent()
    }
    
    /*func setInteractionEvent() {
        eventRequest.eventName = SegmentifyManager.interactionEventName
    }*/
    
    func setImpressionEvent(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.impressionStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        setIDAndSendEvent()
    }
    
    func setWidgetViewEvent(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.widgetViewStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        setIDAndSendEvent()
    }
    
    func setClickView(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.widgetViewStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        setIDAndSendEvent()
    }
    
    func setAdvertisingIdentifier(adIdentifier: String?) {
        if let adIdentifier = adIdentifier {
            eventRequest.advertisingIdentifier = adIdentifier
        }
    }
    
    func setAppVersion(appVersion: String?) {
        if let appVersion = appVersion {
            eventRequest.appVersion = appVersion
        }
    }

    func addParams(key: String, value: AnyObject?) {
        if let value = value {
            eventRequest.extra[key] = value
        }
    }
    
    func addCustomParameter(key: String?, value: AnyObject?) {
        if (key != nil && value != nil) {
            eventRequest.extra[key!] = value
        }
    }
    
    func removeUserParameters() {
        eventRequest.extra.removeAll()
    }
    //TODO user id session id gelene kadar çağıran method yaz
    //private func
    
    private func getUserIdAndSessionIdRequest(success : @escaping () -> Void) {
        var requestURL = NSURL()
        if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
            requestURL = NSURL(string: "https://dce1.segmentify.com/get/key?count=1")!
        } else {
            requestURL = NSURL(string: "https://dce1.segmentify.com/get/key?count=2")!
        }
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            if response == nil {
                self.getUserIdAndSessionIdRequest( success: { () -> Void in
                    self.sendEvent(callback: { (response: [RecommendationModel]) in
                        //callback(response)
                    })
                })
            } else {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do{
                        if let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                            
                            if jsonArray.count > 1 {
                                self.eventRequest.userID = jsonArray[0] as? String
                                self.eventRequest.sessionID = jsonArray[1] as? String
                                UserDefaults.standard.set(self.eventRequest.userID, forKey: "SEGMENTIFY_USER_ID")
                            } else {
                                /*if UserDefaults.standard.object(forKey: "LAST_GENERATED_USER_ID") != nil {

                                    self.eventRequest.userID = UserDefaults.standard.object(forKey: "LAST_GENERATED_FROM_SEGMENTIFY_USER_ID") as? String
                                }*/
                                self.eventRequest.sessionID = jsonArray[0] as? String
                            }
                        }
                        success()
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
            
            }
            task.resume()
    }
    
    func convertStringToDictionary(text: String) -> [[String:AnyObject]]? {
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
    
    func loadArray(recommendations : [[RecommendationModel]]) {
        for recs in recommendations {
            for recObj in recs {
                
            }
        }
    }
}




