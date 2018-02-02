//
//  PurchaseSuccessViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 29.01.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class PurchaseSuccessViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var recommendations: [RecommendationModel] = []
    
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
    
    var productsArray = [Any]()
    
    @IBOutlet weak var lblorderNo: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblproductName: UILabel!
    @IBOutlet weak var lblproductBrand: UILabel!
    @IBOutlet weak var lblproductPrice: UILabel!
    
    
    var orderNo = Int()
    var image = String()
    var productName = String()
    var productBrand = String()
    var productPrice = String()
    var productID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loadImage()
        lblorderNo.text = """
        Purchase Completed 🎉
        Order No: \(orderNo)
        """
        lblproductName.text = productName
        lblproductBrand.text = productBrand
        lblproductPrice.text = productPrice
        sendPageViewRequest()
        sendPurchaseRequest()
    }
    
    
    func sendPageViewRequest() {
        let pageObj = PageModel()
        pageObj.category = "Purchase Success Page"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageObj) { (response: [RecommendationModel]) in
            
        }
    }
    
    func sendPurchaseRequest() {
        let purchObj = CheckoutModel()
        var product = ["price": "\(self.productPrice)", "productId": "\(self.productID)", "quantity": "1"]
        self.productsArray.append(product)
        purchObj.productList = productsArray
        purchObj.totalPrice = NSNumber(value: Int(self.productPrice)!)
        purchObj.orderNo = "\(orderNo)"
        
        
        SegmentifyManager.sharedManager().sendPurchase(segmentifyObject: purchObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
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
            if recObj.instanceId == "scn_6186a632e0d76001" {
                self.setProductInfos(products: recObj.products!)
                self.impressionId = recObj.instanceId
                self.interactionId = recObj.interactionId
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailForPurchaseVC" {
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

    @IBAction func doneButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension PurchaseSuccessViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRecommendationCell", for: indexPath) as? OrderRecommendationCell
        
        
        cell?.lblProductName.text = self.titles[indexPath.row]
        cell?.lblProductBrand.text = self.brands[indexPath.row]
        cell?.lblProductPrice.text = "\(self.prices[indexPath.row])"
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
