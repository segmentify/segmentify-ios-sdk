//
//  BasketViewController.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 19.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var price2Label: UILabel!
    @IBOutlet weak var name2Label: UILabel!
    @IBOutlet weak var price1Label: UILabel!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    
    var images : [String] = []
    var names : [String] = []
    var titles : [String] = []
    var prices : [Int] = []
    var oldPrices : [String] = []
    var productIds : [String] = []
    
    var recommendations : [RecommendationModel] = []
    
    var appKey = "8157d334-f8c9-4656-a6a4-afc8b1846e4c"
    var subDomain = "segmentify-shop.myshopify.com"
    var dataCenterUrl = "https://dce1.segmentify.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SegmentifyAnalyticWrapper.shared.sendPageViewEvent()
        //SegmentifyAnalyticWrapper.shared.sendLoginEvent()
        /*SegmentifyTools.delay(delay: 3) {
         SegmentifyAnalyticWrapper.shared.sendUserChangeEvent()
         }*/
        //SegmentifyAnalyticWrapper.shared.sendUserChangeEvent()
        //SegmentifyAnalyticWrapper.shared.sendLogoutEvent()
        //SegmentifyAnalyticWrapper.shared.sendPaymentSuccessEvent()
        //SegmentifyAnalyticWrapper.shared.sendViewBasketEvent()
        //SegmentifyAnalyticWrapper.shared.sendLoginEvent()
        //SegmentifyAnalyticWrapper.shared.sendPaymentSuccessEvent()
        //SegmentifyAnalyticWrapper.shared.sendPurchaseEvent()
        //SegmentifyAnalyticWrapper.shared.sendRegisterEvent()
        //SegmentifyAnalyticWrapper.shared.sendUserchangeEvent()
        //SegmentifyAnalyticWrapper.shared.sendUserUpdateEvent()
        //SegmentifyAnalyticWrapper.shared.sendCustomevent()
        self.sendPageViewEvent()
        self.sendViewBasketEvent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sendViewBasketEvent() {

        var productsArray = [Any]()
        let firstProduct = ["price":"78","productId":"25799809929","quantity":"1"]
        let secondProduct = ["price":"168","productId":"25799929929","quantity":"2"]
        
        productsArray.append(firstProduct)
        productsArray.append(secondProduct)
        
        let obj = SegmentifyObject()
        obj.products = productsArray
        obj.totalPrice = 100.20
        
        /*SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setViewBasketEvent(segmentifyObject: obj, callback: { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        })*/
    }
    
    func sendPageViewEvent() {
        
        let obj = SegmentifyObject()
        obj.category = "Basket Page"
        //obj.subCategory = "Womenswear"
        /*SegmentifyManager.sharedManager(appKey: appKey, dataCenterUrl: dataCenterUrl, subDomain: subDomain).setPageViewEvent(segmentifyObject: obj, callback: { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        })*/
    }
    
    func setProductInfos(products : [ProductModel]) {
        for product in products {
            self.productIds.append(product.productId!)
            self.titles.append(product.name!)
            self.images.append("https:" + product.image!)
            self.prices.append(product.price!)
            if(product.oldPriceText != nil){
                self.oldPrices.append(product.oldPriceText!)
            }
        }
        self.tableview.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            print("rec obj : \(String(describing: recObj.notificationTitle))")
            print("rec obj : \(String(describing: recObj.products))")
            if recObj.notificationTitle == "People also bought" {
                self.setProductInfos(products: recObj.products!)
            }
        }
    }

}

extension BasketViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.nameLabel.text = self.titles[indexPath.row]
        cell.priceLabel.text = String(self.prices[indexPath.row])
        cell.oldPriceLabel.text=String(self.oldPrices[indexPath.row])
        
        cell.onButtonTapped = {
            print(self.productIds[indexPath.row])
            
            //SegmentifyManager.sharedManager(appKey: self.appKey, dataCenterUrl: self.dataCenterUrl, subDomain: self.subDomain).setAddOrRemoveBasketStepEvent(basketStep: "add", productID: self.productIds[indexPath.row], price: self.prices[indexPath.row] as NSNumber, quantity:1)
        }
        
        if let imageURL = URL(string:  self.images[indexPath.row]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgDeneme.image = image
                    }
                }
            }
        }
        return cell
    }
}
