//
//  SegmentifyManager.swift
//  SegmentifyIosDemo
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
        SegmentifyManager.setup.apiKey = appkey
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
        
        let appkey = SegmentifyManager.setup.apiKey
        guard appkey != nil else {
            print("Error - you must fill appKey before accessing SegmentifyManager.shared")
            return
        }
        eventRequest.apiKey = appkey!
        
        let subDomain = SegmentifyManager.setup.subDomain
        guard subDomain != nil else {
            print("Error - you must fill subdomain before accessing SegmentifyManager.shared")
            return
        }
        eventRequest.subdomain = subDomain!
        
        let dataCenterUrl = SegmentifyManager.setup.dataCenterUrl
        guard dataCenterUrl != nil else {
            print("Error - you must fill dataCenterUrl before accessing SegmentifyManager.shared")
            return
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
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            
        }
        
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
                        insId = instanceId
                    }
                
                    if let interactionId = self.params!["actionId"] as? String {
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
        eventRequest.oldUserId = nil
        let email = segmentifyObject.email
        let username = segmentifyObject.username
        guard email != nil || username != nil else {
            print("Error - you must fill userId or email before accessing sendUserLogout event")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Login Event
    func sendUserLogin(segmentifyObject : UserModel) {
      
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.signInStep
        
        let email = segmentifyObject.email
        let username = segmentifyObject.username
        
        guard email != nil || username != nil else {
            print("Error - you must fill userId or email before accessing sendUserLogin event")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Logout Event
    func sendUserLogout(segmentifyObject : UserModel) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.logoutStep
        let email = segmentifyObject.email
        let username = segmentifyObject.username
        guard email != nil || username != nil else {
            print("Error - you must fill userId or email before accessing sendUserLogout event")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //User Update Event
    func sendUserUpdate(segmentifyObject : UserModel) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.updateUserStep
        let email = segmentifyObject.email
        let username = segmentifyObject.username
        guard email != nil || username != nil else {
            print("Error - you must fill userId or email before accessing sendUserUpdate event")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Change User Event
    func sendChangeUser(segmentifyObject : UserChangeModel) {
        eventRequest.eventName = SegmentifyManager.userChangeEventName
        UserDefaults.standard.set(Constant.IS_USER_SENT_USER_ID, forKey: Constant.IS_USER_SENT_USER_ID)

        let userId = segmentifyObject.userId
        guard userId != nil else {
            //fatalError("Error - you must fill userId before accessing change user event")
            print("Error - you must fill userId before accessing change user event")
            return
        }
        eventRequest.userID = userId
        let lastUserID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        eventRequest.oldUserId = lastUserID
        UserDefaults.standard.set(segmentifyObject.userId, forKey: "UserSentUserId")
        setIDAndSendEvent()
    }

    //Checkout Purchase Event
    func sendPurchase(segmentifyObject : CheckoutModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.userOperationEventName
        eventRequest.userOperationStep = SegmentifyManager.paymentPurchaseStep
        eventRequest.oldUserId = nil
        let totalPrice = segmentifyObject.totalPrice
        guard totalPrice != nil else {
            print("Error - you must fill userId before accessing sendPurchase event")
            return
        }
        let productList = segmentifyObject.productList
        guard productList != nil else {
            print("Error - you must fill productList before accessing sendPurchase event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Checkout Payment Event
    func sendPaymentInformation(segmentifyObject : CheckoutModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.checkoutStep = SegmentifyManager.paymentInformationStep
        eventRequest.oldUserId = nil
        let totalPrice = segmentifyObject.totalPrice
        guard totalPrice != nil else {
            print("Error - you must fill userId before accessing sendPaymentInformation event method")
            return
        }
        let productList = segmentifyObject.productList
        guard productList != nil else {
            print("Error - you must fill productList before accessing sendPaymentInformation event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Checkout Customer Information Event
    func sendCustomerInformation(segmentifyObject : CheckoutModel,callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.checkoutStep = SegmentifyManager.customerInformationStep
        eventRequest.oldUserId = nil
        let totalPrice = segmentifyObject.totalPrice
        guard totalPrice != nil else {
            print("Error - you must fill userId before accessing sendCustomerInformation event method")
            return
        }
        let productList = segmentifyObject.productList
        guard productList != nil else {
            print("Error - you must fill productList before accessing sendCustomerInformation event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Checkout View Basket Event
    func sendViewBasket(segmentifyObject : CheckoutModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.checkoutStep = SegmentifyManager.viewBasketStep
        eventRequest.oldUserId = nil
        let totalPrice = segmentifyObject.totalPrice
        guard totalPrice != nil else {
            print("Error - you must fill userId before accessing sendViewBasket event")
            return
        }
        let productList = segmentifyObject.productList
        guard productList != nil else {
            print("Error - you must fill productList before accessing sendViewBasket event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Add or Remove Basket Event
    func sendAddOrRemoveBasket(segmentifyObject : BasketOperationsModel) {
        eventRequest.eventName = SegmentifyManager.basketOperationsEventName
        eventRequest.oldUserId = nil
        let step = segmentifyObject.step
        guard step != nil else {
            print("Error - you must fill step before accessing sendAddOrRemoveBasket event method")
            return
        }
        let productId = segmentifyObject.productId
        guard productId != nil else {
            print("Error - you must fill productId before accessing sendAddOrRemoveBasket event method")
            return
        }
        let quantity = segmentifyObject.quantity
        guard quantity != nil else {
            print("Error - you must fill quantity before accessing sendAddOrRemoveBasket event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Product View Event
    func sendProductView(segmentifyObject : ProductModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.productViewEventName
        eventRequest.oldUserId = nil
        let productId = segmentifyObject.productId
        guard productId != nil else {
            print("Error - you must fill productId before accessing sendProductView event")
            return
        }
        let name = segmentifyObject.name
        guard name != nil else {
            print("Error - you must fill name before accessing sendProductView event method")
            return
        }
        let url = segmentifyObject.url
        guard url != nil else {
            print("Error - you must fill url before accessing sendProductView event method")
            return
        }
        let image = segmentifyObject.image
        guard image != nil else {
            print("Error - you must fill image before accessing sendProductView event method")
            return
        }
        if segmentifyObject.category != nil {
            if segmentifyObject.categories != nil {
                print("Error - you can not both fill category and categpries parameters")
                return
            } else {
                eventRequest.category = segmentifyObject.category
            }
        } else {
            if let categories = segmentifyObject.categories {
                eventRequest.categories = categories
            } else {
                print("Error - you should fill one of category and categpries parameters")
                return
            }
        }
        let price = segmentifyObject.price
        guard price != nil else {
            print("Error - you must fill price before accessing sendProductView event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEvent()
    }
    
    //Page View Event
    func sendPageView(segmentifyObject : PageModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        
        eventRequest.eventName = SegmentifyManager.pageViewEventName
        eventRequest.oldUserId = nil
        let category = segmentifyObject.category
        guard category != nil else {
            print("Error - you must fill category before accessing sendPageView event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Custom Event
    func sendCustomEvent(segmentifyObject : CustomEventModel, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.customEventName
        let type = segmentifyObject.type
        guard type != nil else {
            print("Error - you must fill type before accessing sendCustomEvent event method")
            return
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        } else {
            if UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") != nil {
                self.eventRequest.userID = UserDefaults.standard.object(forKey: "SEGMENTIFY_USER_ID") as? String
            }
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    func sendWidgetView(segmentifyObject: InteractionModel) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.userOperationStep = SegmentifyManager.widgetViewStep
    }
    
    func sendClick(segmentifyObject : InteractionModel) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.userOperationStep = SegmentifyManager.clickStep
    }
   
    //Alternative Events
     //Register Event
     func sendUserRegister(username : String?, fullName : String?, email : String?, mobilePhone : String?, gender : String?, age : String?, birthdate : String?) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.updateUserStep
        eventRequest.oldUserId = nil
        if let username = username {
            eventRequest.username = username
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
         if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
             eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
         }
         setIDAndSendEvent()
     }
     
     //Login Event
    func sendUserLogin(username: String?, email: String?) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.signInStep
        eventRequest.oldUserId = nil
        if let username = username {
            eventRequest.username = username
        }
        if let email = email {
            eventRequest.email = email
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
         setIDAndSendEvent()
     }
     
     //Logout Event
    func sendUserLogout(username: String?, email: String?) {
         eventRequest.eventName = SegmentifyManager.userOperationEventName
         eventRequest.userOperationStep = SegmentifyManager.signInStep
        eventRequest.oldUserId = nil
        if let username = username {
            eventRequest.username = username
        }
        if let email = email {
            eventRequest.email = email
        }
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
         setIDAndSendEvent()
     }
     
    //User Update Event
    func sendUserUpdate(username : String?, fullName : String?, email : String?, mobilePhone : String?, gender : String?, age : String?, birthdate : String?, isRegistered : Bool?, isLogin : Bool?) {
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
        if let username = username {
            eventRequest.username = username
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
    
    //Checkout Purchase Event
    func sendPurchase(totalPrice : NSNumber, productList:[Any], orderNo : String?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.products = productList
        eventRequest.checkoutStep = SegmentifyManager.paymentPurchaseStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        if let orderNo = orderNo {
            eventRequest.orderNo = orderNo
        }
        setIDAndSendEventWithCallback(callback: callback)
        
    }
    
    //Checkout Payment Event
    func sendPaymentInformation(totalPrice : NSNumber, productList : [Any], callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.checkoutStep = SegmentifyManager.paymentInformationStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Checkout Customer Information Event
    func sendCustomerInformation(totalPrice : NSNumber, productList : [Any], callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.products = productList
        eventRequest.checkoutStep = SegmentifyManager.customerInformationStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Checkout View Basket Event
    func sendViewBasket(totalPrice : NSNumber, productList : [Any], currency : String?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.checkoutEventName
        eventRequest.totalPrice = totalPrice
        eventRequest.products = productList
        eventRequest.checkoutStep = SegmentifyManager.viewBasketStep
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        if let currency = currency {
            eventRequest.currency = currency
        }
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    //Add or Remove Basket Event
    func sendAddOrRemoveBasket(basketStep : String, productID : String, quantity : NSNumber,price : NSNumber?) {
        eventRequest.eventName = SegmentifyManager.basketOperationsEventName
        eventRequest.basketStep = basketStep
        eventRequest.productID = productID
        eventRequest.quantity = quantity
        eventRequest.oldUserId = nil
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        if let price = price {
            eventRequest.price = price
        }
        setIDAndSendEvent()
    }
    
    //Product View Event
    func sendProductView(productID : String, title : String, category : [String], price : NSNumber, brand : String?, stock : Bool?, url: String, image : String,imageXS: String?, imageS: String?, imageM: String?, imageL: String?, imageXL: String?, gender:String?, colors:[String]?, sizes:[String]?, labels:[String]?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void ) {
        
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
        if let stock = stock {
            eventRequest.stock = stock
        }
        if let imageXS = imageXS {
            eventRequest.imageXS = imageXS
        }
        if let imageS = imageS {
            eventRequest.imageS = imageS
        }
        if let imageM = imageM {
            eventRequest.imageM = imageM
        }
        if let imageL = imageL {
            eventRequest.imageL = imageL
        }
        if let imageXL = imageXL {
            eventRequest.imageXL = imageXL
        }
        if let gender = gender {
            eventRequest.gender = gender
        }
        if let colors = colors {
            eventRequest.colors = colors
        }
        if let sizes = sizes {
            eventRequest.sizes = sizes
        }
        if let labels = labels {
            eventRequest.labels = labels
        }
        setIDAndSendEventWithCallback(callback: callback)
    }

    //Page View Event
    func sendPageView(category : String, subCategory : String?, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.pageViewEventName
        eventRequest.category = category
        eventRequest.oldUserId = nil
        
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        if let subCategory = subCategory {
            eventRequest.subCategory = subCategory
        }
        setIDAndSendEventWithCallback(callback: callback)
    }

    func sendCustomEvent(type : String, callback: @escaping (_ recommendation: [RecommendationModel]) -> Void) {
        eventRequest.eventName = SegmentifyManager.customEventName
        eventRequest.type = type
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        eventRequest.oldUserId = nil
        setIDAndSendEventWithCallback(callback: callback)
    }
    
    func sendImpression(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.impressionStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        eventRequest.oldUserId = nil
        setIDAndSendEvent()
    }
    
    func sendWidgetView(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.widgetViewStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
        eventRequest.oldUserId = nil
        setIDAndSendEvent()
    }
    
    func sendClickView(instanceId : String, interactionId : String) {
        eventRequest.eventName = SegmentifyManager.interactionEventName
        eventRequest.type = SegmentifyManager.widgetViewStep
        eventRequest.instanceId = instanceId
        eventRequest.interactionId = interactionId
        if UserDefaults.standard.object(forKey: "UserSentUserId") != nil {
            eventRequest.userID = UserDefaults.standard.object(forKey: "UserSentUserId") as? String
        }
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




