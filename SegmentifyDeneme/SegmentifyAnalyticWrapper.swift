//
//  SegmentifyAnalyticWrapper.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import Foundation

final class SegmentifyAnalyticWrapper {
    
    var appKey = String()
    var subDomain = String()
    var dataCenterUrl = String()
    
    private init() {
        appKey = "8157d334-f8c9-4656-a6a4-afc8b1846e4c"
        subDomain = "segmentify-shop.myshopify.com"
        dataCenterUrl = "https://dce1.segmentify.com"
    }
    
    static let shared = SegmentifyAnalyticWrapper()
    
    var segmentify : SegmentifyManager!
    
    func sendPageViewEvent() {
        
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setPageViewEvent(category: "Product Page", subCategory: nil, pageUrl: "https://www.mobilecp.boyner.com.tr/mobile2/mbProduct/GetCombinedProducts?ProductID=658386")
        let obj = SegmentifyObject()
        obj.category = "Category Page"

        obj.subCategory = "Womenswear"
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setPageViewEvent(segmentifyObject: obj)
    }
    
    func sendLoginEvent() {
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setLoginEvent(username: "aaturgay", userId: "1234")
        let obj = SegmentifyObject()
        obj.username = "aaturgay"
        obj.userID = "1234"
        //TODO SegmentifyManager.config = Config(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain)
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).userLogin(segmentifyObject: obj)
    }
    
    func sendRegisterEvent() {
        /*let obj = SegmentifyObject()

        obj.username = "aaturgay"
        obj.fullName = "ata anil turgat"
        obj.email = "aturgay@gmail.cmpo"
        obj.mobilePhone = "05426005299"
        obj.gender = "Male"
        obj.age = "50"
        obj.birthdate = "01.01.01"
        obj.memberSince = "21.12.2012"
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setRegisterEvent(segmentifyObject: obj, step: UserEventSteps.signin.rawValue)
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).userRegister(segmentifyObject: obj, step: "")*/
        
    }
    
    func sendLogoutEvent() {
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setLogoutEvent(username: "aaturgay")
        let obj = SegmentifyObject()
        obj.username = "aaturgay"
        obj.userID = "aatur"
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setLogoutEvent(segmentifyObject: obj)
    }
    
    func sendUserUpdateEvent() {
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setUserUpdateEvent(username: "aaturgay", fullName: "ata anil turgay", email: "aturgay@com", mobilePhone: "05423949939", gender: "Male", age: "50", birthdate: "01.01.2017", isRegistered: true, isLogin: true)
        let obj = SegmentifyObject()
        obj.username = "aaturgay"
        obj.email = "aturgay@mynetçcm"
        obj.fullName = "adfssd"
        obj.mobilePhone = "231404ı594"
        obj.gender = "Male"
        obj.age = "50"
        obj.birthdate = "01.0*1.2r"
        obj.isRegistered = true
        obj.isLogin = true
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setUserUpdateEvent(segmentifyObject: obj)
    }
    
    func sendViewBasketEvent() {
        var productsArray = [Any]()
        let productsDict = ["price":"78","productId":"25799809929","quantity":"1"]
        productsArray.append(productsDict)
        
        let obj = SegmentifyObject()
        obj.products = productsArray
        obj.userID = "1234"
        
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setViewBasketEvent(segmentifyObject: obj, callback: { (response: RecommendationModel) in
            print("rec model : \(String(describing: (response.products![0].brand)!))")
        })

        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setViewBasketEvent(totalPrice: 78, currency: nil, basketID: nil, orderNo: nil, products: productsArray)
    }
    
    /*func sendProductView() {
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setProductViewEvent(productID: "25799860937", title: "Asymmetric Dress in Black", category: "Womenswear", price: 578, brand: "Amelia Toro", currency: "TL", stock: true, url: "https://segmentify-shop.myshopify.com/products/asymmetric-dress-black", image: "//cdn.shopify.com/s/files/1/1524/5822/products/2014_11_17_Lana_Look034_02_300x300.jpg?v=1475497696")
     
    }*/
    
    func sendPurchaseEvent() {
        var productsArray = [Any]()
        let productsDict = ["price":"78","productId":"25799809929","quantity":"1"]
        productsArray.append(productsDict)
        
        let obj = SegmentifyObject()
        obj.products = productsArray
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setPurchaseEvent(segmentifyObject: obj)
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setPurchaseEvent(totalPrice: 100, currency: nil, basketID: nil, orderNo: "BEY-20171227-1149208", products: productsArray)
    }
    
    func sendPaymentSuccessEvent() {
        var productsArray = [Any]()
        let productsDict = ["price":"78","productId":"25799809929","quantity":"1"]
        productsArray.append(productsDict)
        
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setPurchaseEvent(totalPrice: 78, currency: nil, basketID: nil, orderNo: nil, products: productsArray)
    }
    
    func sendUserchangeEvent() {
        //SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setChangeUserEvent()
    }
    
    func sendCustomevent() {
        let obj = SegmentifyObject()
        obj.type = "deneme"
        SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setCustomEvent(segmentifyObject: obj)
    }

}

extension SegmentifyAnalyticWrapper : SegmentifyManagerDelegate {
    func segmentifyCallback(recommendation: RecommendationModel) {
        print("rec delegate works")
    }
}


