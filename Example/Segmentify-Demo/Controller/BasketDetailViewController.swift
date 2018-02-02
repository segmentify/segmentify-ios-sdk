//
//  BasketDetailViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 26.01.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class BasketDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductBrand: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    var recommendations : [RecommendationModel] = []
    
    var images : [String] = []
    var names : [String] = []
    var titles : [String] = []
    var prices : [Int] = []
    var oldPrices : [String] = []
    var productIds : [String] = []
    var brands: [String] = []
    var urls: [String] = []
    var infoStock: [Bool] = []
    var category: [String] = []
    var categories: [String] = []
    
    var impressionId: String?
    var interactionId:String?
    
    var orderNoRandom: Int = 0

    var productID = String()
    var productName = String()
    var productPrice: NSNumber = 0.0
    var productBrand = String()
    var image = String()
    
    var productsArray = [Any]()
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderNoRandom = Int(arc4random_uniform(100000)+1)
        lblProductName.text = productName
        lblProductPrice.text = "\(productPrice)"
        lblProductBrand.text = productBrand
        // set corner radius to purchase button
        purchaseButton.layer.cornerRadius = 7
        loadImage()
        sendPageViewRequest()
        sendCheckoutRequest()
    }
    
    func sendPageViewRequest() {
        let pageViewObj = PageModel()
        pageViewObj.category = "Basket Page"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
            
            
        }
    }
    
    func sendCheckoutRequest() {
        let checkObj = CheckoutModel()
        checkObj.productList = productsArray
        checkObj.totalPrice = self.productPrice
        checkObj.orderNo = "\(orderNoRandom)"
        
        SegmentifyManager.sharedManager().sendViewBasket(segmentifyObject: checkObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    
    @IBAction func purchaseButton(_ sender: UIButton) {
        
    }
    
    func loadImage() {
        if let imageURL = URL(string: image) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imgView.image = image
                    }
                }
            }
        }
    }
    
    func setProductInfos(products : [ProductRecommendationModel]) {
        for product in products {
            self.productIds.append(product.productId!)
            self.titles.append(product.name!)
            self.images.append("https:" + product.image!)
            //self.urls.append(product.url!)
            //self.infoStock.append(product.inStock!)
            if product.category != nil {
                self.category.append(product.category!)
            } else {
                self.category.append("")
            }
            if product.price != nil {
                self.prices.append(product.price!)
            } else {
                self.prices.append(0)
            }
            self.brands.append(product.brand!)
            if(product.oldPriceText != nil){
                self.oldPrices.append(product.oldPriceText!)
            }
        }
        self.tableView.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            if recObj.instanceId == "ext_basket_rec" {
                self.setProductInfos(products: recObj.products!)
                self.notificationTitle.text = recObj.notificationTitle
                self.impressionId = recObj.instanceId
                self.interactionId = recObj.interactionId
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderVC" {
            let destinationViewController = segue.destination as? PurchaseSuccessViewController
            
            destinationViewController?.orderNo = self.orderNoRandom
            destinationViewController?.productPrice = "\(self.productPrice)"
            destinationViewController?.productName = self.productName
            destinationViewController?.productBrand = self.productBrand
            destinationViewController?.image = self.image
            destinationViewController?.productID = self.productID
        }
        
        if segue.identifier == "productDetailForBasketVC" {
            var indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            
            let destinationViewController = segue.destination as? ProductDetailViewController
            destinationViewController!.productName = self.titles[indexPath.row]
            destinationViewController?.productBrand = self.brands[indexPath.row]
            destinationViewController?.productPrice = "\(self.prices[indexPath.row])"
            destinationViewController?.image = self.images[indexPath.row]
            destinationViewController?.productID = self.productIds[indexPath.row]
            //destinationViewController?.productURL = self.urls[indexPath.row]
            //destinationViewController?.productInfoStock = self.infoStock[indexPath.row]
            destinationViewController?.productCategory = self.category[indexPath.row]
            destinationViewController?.interactionId = self.interactionId
            destinationViewController?.impressionId = self.impressionId
        }
    }
    
}

extension BasketDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketRecommendationCell", for: indexPath) as? BasketRecommendationCell
        
        
        cell?.lblproductName.text = self.titles[indexPath.row]
        cell?.lblproductBrand.text = self.brands[indexPath.row]
        cell?.lblproductPrice.text = "\(self.prices[indexPath.row])"
        //cell?.lblOldPrice.text = self.oldPrices[indexPath.row]
        
        
        if let imageURL = URL(string:  self.images[indexPath.row]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell?.imgView.image = image
                    }
                }
            }
        }
        return cell!
    }
}
