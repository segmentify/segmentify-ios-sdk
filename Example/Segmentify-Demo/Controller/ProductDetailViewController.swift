//
//  ProductDetailViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 26.01.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationTitle: UILabel!
    
    var recommendations : [RecommendationModel] = []
    
    @IBOutlet weak var addToBasketButton: UIButton!
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
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductBrand: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    var image = String()
    var productName: String?
    var productBrand: String?
    var productPrice: String?
    var productID = String()
    var productURL = String()
    var productInfoStock = Bool()
    var productCategory = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToBasketButton.layer.cornerRadius = 7
        lblProductName.text = productName
        lblProductBrand.text = productBrand
        lblProductPrice.text = productPrice
        sendPageViewRequest()
        sendProductViewRequest()
        sendClickEvent()
        loadImage()
    }
    
    func sendClickEvent(){
        SegmentifyManager.sharedManager().sendClickView(instanceId: self.impressionId!, interactionId: productID)
    }

    
    func sendPageViewRequest() {
        let pageViewObj = PageModel()
        pageViewObj.category = "Product Page"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
            
            
        }
    }
    
    func sendProductViewRequest() {
        let prodViewObj = ProductModel()
        prodViewObj.productId = self.productID
        prodViewObj.title = self.productName
        prodViewObj.url = self.productURL
        prodViewObj.image = self.image.replacingOccurrences(of: "https:", with: "")
        prodViewObj.category = self.productCategory
        prodViewObj.price =  NSNumber(value: Int(self.productPrice!)!)
        prodViewObj.noUpdate = true
        SegmentifyManager.sharedManager().sendProductView(segmentifyObject: prodViewObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
    
        }
    }
    
    // add basket request method
    func sendAddToBasketRequest() {
        //define basket object
        let basketObj = BasketModel()
        basketObj.price = NSNumber(value: Int(self.productPrice!)!)
        basketObj.productId = self.productID
        basketObj.quantity = 1
        basketObj.step = "add"
        
        // send request
        SegmentifyManager.sharedManager().sendAddOrRemoveBasket(segmentifyObject: basketObj)
    }
    
    @IBAction func addToBasketBUtton(_ sender: UIButton) {
        sendAddToBasketRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "basketDetail" {
            let destinationViewController = segue.destination as? BasketDetailViewController
            
            destinationViewController?.productName = self.productName!
            destinationViewController?.productBrand = self.productBrand!
            destinationViewController?.productPrice = NSNumber(value: Int(self.productPrice!)!)
            destinationViewController?.image = self.image
            destinationViewController?.productID = self.productID
        }
       
        if segue.identifier == "productDetailForProductVC" {
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
    
    func loadImage() {
        if let imageURL = URL(string: image) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.productImage.image = image
                    }
                }
            }
            //tableView.reloadData()
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
            if recObj.instanceId == "ext_product_rec" {
                self.setProductInfos(products: recObj.products!)
                self.notificationTitle.text = recObj.notificationTitle
                self.impressionId = recObj.instanceId
                self.interactionId = recObj.interactionId
            }
        }
    }
    
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCell", for: indexPath) as? RecommendationCell
        
        cell?.lblproductName.text = self.titles[indexPath.row]
        cell?.lblproductBrand.text = self.brands[indexPath.row]
        cell?.lblproductPrice.text = "\(self.prices[indexPath.row])"
        //cell?.lblOldPrice.text = self.oldPrices[indexPath.row]
    
        if let imgURL = URL(string:  self.images[indexPath.row]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imgURL)
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
