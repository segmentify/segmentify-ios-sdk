//
//  SegmentifyManager.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation

class SegmentifyManager {

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
    static let paymentInformationStep = "payment-info"
    static let paymentPurchaseStep = "purchase"
    static let signInStep = "signin"
    static let registerStep = "signup"
    static let logoutStep = "signout"
    static let updateUserStep = "update"
    static let impressionStep = "impression"
    static let widgetViewStep = "widget_view"
    static let clickStep = "click"
    
    static let startIndex = 0
    
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
    private var currentKey : String?
    private var staticItemsArrayCount : Int = Int()
    private var currentNewArray : [RecommendationModel]?
    
    private var newRecommendationArray : [RecommendationModel] = []
    
    private var testStaticProducts : [AnyHashable:Any]?
    private var testOtherProducts : [AnyHashable:Any]?
    private var minusIndex : Int?

    private var currentRecModel = RecommendationModel()
    private var products : [ProductRecommendationModel] = []
    private static var segmentifySharedInstance: SegmentifyManager?
    private var eventRequest = SegmentifyRegisterRequest()
    private static let setup = ConfigModel()
    
    class func sharedManager() -> SegmentifyManager {
        if segmentifySharedInstance == nil {
            segmentifySharedInstance = SegmentifyManager.init()
        }
        return segmentifySharedInstance!
    }
    
    class func config(appkey: String, dataCenterUrl: String, subDomain: String) {
        SegmentifyManager.setup.appKey = appkey
        SegmentifyManager.setup.dataCenterUrl = dataCenterUrl
        SegmentifyManager.setup.subDomain = subDomain
        
        _ = sharedManager()
    }
    
    var debugMode = false {
        didSet {
            SegmentifyConnectionManager.sharedInstance.debugMode = debugMode
        }
    }
    
    init() {
        self.eventRequest = SegmentifyRegisterRequest()
        /*if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }*/
        let appkey = SegmentifyManager.setup.appKey
        guard appkey != nil else {
            fatalError("Error - you must fill appKey before accessing SegmentifyManager.shared")
        }
        eventRequest.appKey = appkey
        
        let subDomain = SegmentifyManager.setup.subDomain
        guard subDomain != nil else {
            fatalError("Error - you must fill subdomain before accessing SegmentifyManager.shared")
        }
        eventRequest.subdomain = subDomain!
        
        let dataCenterUrl = SegmentifyManager.setup.dataCenterUrl
        guard dataCenterUrl != nil else {
            fatalError("Error - you must fill dataCenterUrl before accessing SegmentifyManager.shared")
        }
        eventRequest.dataCenterUrl = dataCenterUrl!

        eventRequest.sdkVersion = SegmentifyManager.sdkVersion
        eventRequest.token = SegmentifyTools.retrieveUserDefaults(userKey: SegmentifyManager.tokenKey) as? String

        if let lastRegister = SegmentifyTools.retrieveUserDefaults(userKey: SegmentifyManager.registerKey) {
            let lastRequest = SegmentifyRegisterRequest.init(withJsonString: lastRegister as! String)
            eventRequest.extra = (lastRequest?.extra)!
        }
        self.currentKey = "RECOMMENDATION_SOURCE_STATIC_ITEMS"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeDeactive),
                                               name: .UIApplicationDidEnterBackground,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIApplicationDidBecomeActive,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIApplicationDidEnterBackground,
                                                  object: nil)
    }
    
    @objc private func applicationDidBecomeActive() {
        print("applicationDidBecomeActive")
        self.getUserIdAndSessionIdRequest( success: { () -> Void in
            print("received user id and session id")
        })
    }
    
    @objc private func applicationDidBecomeDeactive() {
        print("applicationDidBecomeDeactive")
        self.eventRequest.sessionID = nil
    }

    // MARK: Request Builders
    func setIDAndSendEvent() {
        if self.eventRequest.sessionID == nil {
            self.getUserIdAndSessionIdRequest( success: { () -> Void in
                self.sendEvent(callback: { (response: [RecommendationModel]) in
                })
            })
        } else {
            self.sendEvent(callback: { (response: [RecommendationModel]) in
            })
        }
    }
    
    func setIDAndSendEventWithCallback(callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        if self.eventRequest.sessionID == nil {
            self.getUserIdAndSessionIdRequest( success: { () -> Void in
                self.sendEvent(callback: { (response: [RecommendationModel]) in
                    callback(response)
                })
            })
        } else {
            self.sendEvent(callback: { (response: [RecommendationModel]) in
                callback(response)
            })
        }
    }
    
    func sendEvent(callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        SegmentifyConnectionManager.sharedInstance.request(requestModel: eventRequest, success: {(response: [String:AnyObject]) in
            
            guard let responses = response["responses"] as? [[Dictionary<AnyHashable,Any>]] else {
                print("error : \(response["statusCode"]! as Any)")
                return
            }
            
            for (_, obj) in responses[0].enumerated() {
                self.minusIndex = Int()
                guard let params = obj["params"] as? Dictionary<AnyHashable, Any> else {
                    return
                }
                self.params = params

                guard let dynamicItems = self.params!["dynamicItems"] as? String else {
                    print("params['dynamicItems'] is not valid")
                    return
                }
                
                guard let dynamicDic = SegmentifyTools.convertStringToDictionary(text: dynamicItems) else {
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
                
                guard let staticItemsDic = SegmentifyTools.convertStringToDictionary(text: staticItems) else {
                    print("cannot converted string to json")
                    return
                }
                
                if staticItemsDic.count > 0 {
                    self.validStaticItem = true
                }
                
                
                
                var insId : String = String()
                var interId : String = String()
                    if let instanceId = self.params!["instanceId"] as? String {
                        print("instanceId : \(instanceId)")
                        //UserDefaults.standard.set(instanceId, forKey: "instanceId")
                        insId = instanceId
                    }
                
                    if let interactionId = self.params!["actionId"] as? String {
                        //UserDefaults.standard.set(interactionId, forKey: ",interactionId")
                        interId = interactionId
                    }
                
                    if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                        self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
                    }
                self.sendImpression(instanceId: insId, interactionId: interId)
                
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
        var newProdArray = [ProductRecommendationModel]()

        if dynamicItemsArray.count > 0 {
            for dynObj in dynamicItemsArray {
                
                self.currentKey = dynObj.key
                if let products = recommendedProducts[dynObj.key!] as? [[AnyHashable:Any]] {
                    if products.count > 0 {
                        
                        self.createRecomendation(title: notificationTitle, itemCount: dynObj.itemCount!, products: products)
                        for product in currentRecModel.products!{
                            if newProdArray.contains(where: {$0.productId==product.productId}){ }
                            else{
                                if newProdArray.count <= (validStaticItem ? staticItemsArrayCount +  dynObj.itemCount! - 1 : dynObj.itemCount! - 1) {
                                    newProdArray.append(product)
                                }
                            }
                        }
                        self.products.removeAll()
                        currentRecModel = RecommendationModel()
                    }
                }
            }
            let newRecModel = RecommendationModel()
            newRecModel.notificationTitle = notificationTitle
            newRecModel.products = newProdArray
            recommendations.append(newRecModel)
        }
    }
    
    private func createRecomendation(title:String, itemCount:Int, products:[[AnyHashable:Any]]) {
        var staticProducts = [ProductRecommendationModel]()
        if !self.products.isEmpty {
            for staticProduct in self.products{
                staticProducts.append(staticProduct.copy() as! ProductRecommendationModel)
            }
        }
        
        for (_, obj) in products.enumerated() {

            let proObj = ProductRecommendationModel()
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

            if self.products.contains(where: {$0.productId == proObj.productId}) {
                minusIndex = minusIndex! - 1
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
    func sendUserRegister(segmentifyObject: UserModel) {
        
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.registerStep
        
        if let username = segmentifyObject.username {
            eventRequest.username = username
        }
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
    func sendUserLogin(segmentifyObject : UserModel) {
      
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.signInStep
        eventRequest.oldUserId = nil

        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        if let username = segmentifyObject.username {
            eventRequest.username = username
        }
        setIDAndSendEvent()
    }
    
    //Logout Event
    func sendUserLogout(segmentifyObject : UserModel) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.logoutStep
        if let username = segmentifyObject.username {
            eventRequest.username = username
        }
        setIDAndSendEvent()
    }
    
    //User Update Event
    func sendUserUpdate(segmentifyObject : UserModel) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.updateUserStep
        eventRequest.oldUserId = nil
        if let username = segmentifyObject.username {
            eventRequest.username = username
        }
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
    func sendChangeUser(segmentifyObject : UserChangeModel) {
        eventRequest.eventName = SegmentifyManager.userChangeEventName
        UserDefaults.standard.set(Constant.IS_USER_SENT_USER_ID, forKey: Constant.IS_USER_SENT_USER_ID)

        let userId = segmentifyObject.userId
        guard userId != nil else {
            fatalError("Error - you must fill userId before accessing change user event")
        }
        eventRequest.userID = userId
        let lastUserID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        eventRequest.oldUserId = lastUserID
        UserDefaults.standard.set(segmentifyObject.userId, forKey: "UserSentUserId")
        //eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        
        /*if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
            eventRequest.oldUserId = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
        }*/
        setIDAndSendEvent()
    }
    
    //Checkout Purchase Event
    func sendPurchase(segmentifyObject : CheckoutModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.paymentPurchaseStep
        
        let totalPrice = segmentifyObject.totalPrice
        guard totalPrice != nil else {
            print("Error - you must fill totalPrice before accessing sendPurchase event method")
            fatalError("Error - you must fill totalPrice before accessing sendPurchase event method")
        }
        let productList = segmentifyObject.productList
        guard productList != nil else {
            print("Error - you must fill productList before accessing sendPurchase event method")
            fatalError("Error - you must fill productList before accessing sendPurchase event method")
        }

        setIDAndSendEvent()
    }
    
    //Checkout Payment Event
    func sendPaymentInformation(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.checkoutStep = SegmentifyManager.paymentInformationStep
        eventRequest.oldUserId = nil
        
        /*if let totalPrice = segmentifyObject.totalPrice {
            eventRequest.totalPrice = totalPrice
        }
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
        }*/
        setIDAndSendEvent()
    }
    
    //Checkout Customer Information Event
    func sendCustomerInformation(segmentifyObject : SegmentifyObject,callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.checkoutStep = SegmentifyManager.customerInformationStep
        eventRequest.oldUserId = nil
        
        /*if let totalPrice = segmentifyObject.totalPrice {
            eventRequest.totalPrice = totalPrice
        }
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
        }*/
        setIDAndSendEvent()
    }
    
    //Checkout View Basket Event
    func sendViewBasket(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.checkoutStep = SegmentifyManager.viewBasketStep
        eventRequest.oldUserId = nil
        
        /*if let totalPrice = segmentifyObject.totalPrice {
            eventRequest.totalPrice = totalPrice
        }
        if let currency = segmentifyObject.currency {
            eventRequest.currency = currency
        }
        
        if let products = segmentifyObject.products {
            eventRequest.products = products
        }
        if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }*/
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Add or Remove Basket Event
    func sendAddOrRemoveBasket(segmentifyObject : SegmentifyObject) {
        eventRequest.eventName = SegmentifyManager.basketOperationsEventName
        /*eventRequest.basketStep = segmentifyObject.basketStep
        if let productId = segmentifyObject.productID {
            eventRequest.productID = productId
        }
        if let price = segmentifyObject.price {
            eventRequest.price = price
        }
        if let quantity = segmentifyObject.quantity {
            eventRequest.quantity = quantity
        }
        eventRequest.oldUserId = nil*/
        setIDAndSendEvent()
    }
    
    //Product View Event
    func sendProductView(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.productViewEventName
        /*if let productId = segmentifyObject.productID {
            eventRequest.productID = productId
        }
        if let title = segmentifyObject.title {
            eventRequest.title = title
        }
        if let price = segmentifyObject.price {
            eventRequest.price = price
        }
        if let categories = segmentifyObject.categories {
            eventRequest.categories = categories
        }
        if let image = segmentifyObject.image {
            eventRequest.image = image
        }
        if let url = segmentifyObject.url {
            eventRequest.url = url
        }
        
        eventRequest.userOperationStep = nil
        eventRequest.oldUserId = nil
        
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
        }*/
        setIDAndSendEvent()
    }
    
    //Page View Event
    func sendPageView(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        
        eventRequest.eventName = SegmentifyManager.pageViewEventName
        eventRequest.userOperationStep = nil
        /*if let category = segmentifyObject.category {
            eventRequest.category = category
        }
        if let subCategory = segmentifyObject.subCategory {
            eventRequest.subCategory = subCategory
        }*/
        if let pageUrl = segmentifyObject.pageUrl {
            eventRequest.pageUrl = pageUrl
        }
        /*if let lang = segmentifyObject.lang {
            eventRequest.lang = lang
        }
        if let categories = segmentifyObject.categories {
            eventRequest.categories = categories
        }*/
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Custom Event
    func sendCustomEvent(segmentifyObject : SegmentifyObject, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.customEventName
        /*if let type = segmentifyObject.type {
            eventRequest.type = type
        }*/
        if let params = segmentifyObject.params {
            eventRequest.params = params
        }
        eventRequest.oldUserId = nil
        setIDAndSendEventWithCallback(callback: callback)
    }
   
     
     //Register Event
     func sendUserRegister(username : String, fullName : String?, email : String?, mobilePhone : String?, gender : String?, age : String?, birthdate : String?) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.updateUserStep
         eventRequest.username = username
        eventRequest.oldUserId = nil
     
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
         setIDAndSendEvent()
     }
     
     //Login Event
     func sendUserLogin(username: String, userId: String) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.signInStep
         eventRequest.username = username
         eventRequest.userID = userId
        eventRequest.oldUserId = nil
         setIDAndSendEvent()
     }
     
     //Logout Event
     func sendUserLogout(username: String) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.signInStep
         eventRequest.username = username
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
         setIDAndSendEvent()
     }
     
    //User Update Event
    func sendUserUpdate(username : String, fullName : String?, email : String?, mobilePhone : String?, gender : String?, age : String?, birthdate : String?, isRegistered : Bool?, isLogin : Bool?) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.updateUserStep
        eventRequest.username = username
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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
    func sendPaymentSuccess(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        //eventRequest.checkoutStep = SegmentifyManager.paymentSuccessStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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
    func sendPurchase(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentPurchaseStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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
        setIDAndSendEventWithCallback(callback: callback)
        
    }
    
    //Checkout Payment Event
    func sendPaymentInformation(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentInformationStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Checkout Customer Information Event
    func sendCustomerInformation(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.customerInformationStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Checkout View Basket Event
    func sendViewBasket(totalPrice : NSNumber, currency : String?, basketID : String?, orderNo : String?, products : [Any]?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.viewBasketStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Add or Remove Basket Event
    func sendAddOrRemoveBasket(basketStep : String, productID : String, price : NSNumber?, quantity : NSNumber?) {
        eventRequest.eventName = SegmentifyManager.basketOperationsEventName
        eventRequest.basketStep = basketStep
        eventRequest.productID = productID
        
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        eventRequest.oldUserId = nil
        if let price = price {
            eventRequest.price = price
        }
        if let quantity = quantity {
            eventRequest.quantity = quantity
        }
        setIDAndSendEvent()
    }
    
    //Product View Event
    func sendProductView(productID : String, title : String, category : [String], price : NSNumber, brand : String?, currency : String?, stock : Bool?, url: String, image : String, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void ) {
        eventRequest.eventName = SegmentifyManager.productViewEventName
        eventRequest.productID = productID
        eventRequest.title = title
        eventRequest.price = price
        eventRequest.categories = category
        eventRequest.image = image
        eventRequest.url = url
        eventRequest.oldUserId = nil
        
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        
        if let brand = brand {
            eventRequest.brand = brand
        }
        if let currency = currency {
            eventRequest.currency = currency
        }
        if let stock = stock {
            eventRequest.stock = stock
        }
        setIDAndSendEventWithCallback(callback: callback)
    }

    //Page View Event
    func sendPageView(category : String, subCategory : String?, pageUrl : String?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.pageViewEventName
        eventRequest.category = category
        eventRequest.oldUserId = nil
        
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        if let subCategory = subCategory {
            eventRequest.subCategory = subCategory
        }
        if let pageUrl = pageUrl {
            eventRequest.pageUrl = pageUrl
        }
        setIDAndSendEventWithCallback(callback: callback)
    }

    func sendCustomEvent(params : AnyObject?, type : String, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.customEventName
        eventRequest.type = type
        eventRequest.oldUserId = nil
        if let params = params {
            eventRequest.params = params as? [String : AnyObject]
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    func sendImpression(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.impressionStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        eventRequest.oldUserId = nil
        setIDAndSendEvent()
    }
    
    func sendWidgetView(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.widgetViewStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        eventRequest.oldUserId = nil
        setIDAndSendEvent()
    }
    
    func sendClickView(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.widgetViewStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        eventRequest.oldUserId = nil
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
    
    //private func
    
    private func getUserIdAndSessionIdRequest(success : @escaping () -> Void) {
        var requestURL : URL!
        if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
            requestURL = URL(string: "https://dce1.segmentify.com/get/key?count=1")!
        } else {
            requestURL = URL(string: "https://dce1.segmentify.com/get/key?count=2")!
        }
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
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
}




