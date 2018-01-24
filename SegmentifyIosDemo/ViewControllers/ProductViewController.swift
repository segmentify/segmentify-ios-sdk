//
//  ProductViewController.swift
//  SegmentifyIosDemo
//
//  Created by Ata Anıl Turgay on 24.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

//
//  ProductViewController.swift
//  SegmentifyDeneme
//
//  Created by Cem Ayan on 24.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    var images : [String] = []
    var names : [String] = []
    var titles : [String] = []
    var prices : [Int] = []
    var oldPrices : [String] = []
    var productIds : [String] = []
    var recommendations : [RecommendationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendPageViewEvent()
        self.sendProductViewEvent()
    }
    
    func sendPageViewEvent() {
        let obj = PageModel()
        obj.category = "Product Page"
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: obj) { (response: [RecommendationModel]) in
            
        }
        //obj.subCategory = "Womenswear"
    }
    
    func sendProductViewEvent() {
        let productObj = ProductModel()
        productObj.title = "Asymmetric Dress in Black"
        productObj.category = "Womenswear"
        productObj.image = "//cdn.shopify.com/s/files/1/1524/5822/products/2014_11_17_Lana_Look034_02_300x300.jpg?v=1475497696"
        productObj.url = "https://segmentify-shop.myshopify.com/products/asymmetric-dress-black"
        productObj.inStock = true
        productObj.brand = "Amelia Toro"
        productObj.price = 578
        productObj.productId = "25799860937"
        
        SegmentifyManager.sharedManager().sendProductView(segmentifyObject: productObj) { (response: [RecommendationModel]) in
        }
    }
    
    @IBAction func addToBasketButton() {
        
        SegmentifyManager.config(appkey: Constant.segmentifyApiKey, dataCenterUrl: Constant.segmentifyDataCenterUrl, subDomain: Constant.segmentifySubDomain)
        
        let obj = BasketModel()
        obj.productId = "25799860937"
        obj.price = 578
        obj.quantity = 1
        obj.step = "add"
        
        SegmentifyManager.sharedManager().sendAddOrRemoveBasket(segmentifyObject: obj)
    }
}
