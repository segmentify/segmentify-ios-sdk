//
//  ViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 26.01.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collecView: UICollectionView!
    //var userInfo = String()
    
    @IBOutlet weak var notificationTitle: UILabel!
    
    var recommendations : [RecommendationModel] = []

    // for table view
    var images : [String] = []
    var titles : [String] = []
    var prices : [Int] = []
    var oldPrices : [String] = []
    var productIds : [String] = []
    var brands: [String] = []
    var urls: [String] = []
    var infoStock: [Bool] = []
    var category: [String] = []
    var categories: [String] = []
    var names : [String] = []
    var interactionId:String?
    var impressionId:String?
    
    
    
    // for collection view
    var images2 : [String] = []
    var titles2 : [String] = []
    var prices2 : [Int] = []
    var oldPrices2 : [String] = []
    var productIds2 : [String] = []
    var brands2: [String] = []
    var urls2: [String] = []
    var infoStock2: [Bool] = []
    var category2: [String] = []
    var categories2: [String] = []
    var names2 : [String] = []
    var interactionId2:String?
    var impressionId2:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // define logoutTapped function to left bar button
        let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(logoutTapped(_:)))
        navigationItem.leftBarButtonItem = leftButton
        // no large title
        navigationController?.navigationBar.prefersLargeTitles = true
        // pageView Request
        sendPageViewRequest()
        // update table view
        tableView.reloadData()
    }
    
    // send page view request
    func sendPageViewRequest() {
        let pageViewObj = PageModel()
        pageViewObj.category = "Home Page"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    //
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            if recObj.instanceId == "scn_61869cb94553e000" {
                self.setProductInfos(products: recObj.products!)
                self.interactionId = recObj.interactionId
                self.impressionId = recObj.instanceId
                SegmentifyManager.sharedManager().sendWidgetView(instanceId: self.impressionId!, interactionId: self.interactionId!)
            }
            
            if recObj.instanceId == "ext_home_rec" {
                self.setProductInfos2(products: recObj.products!)
                self.interactionId2 = recObj.interactionId
                self.impressionId2 = recObj.instanceId
                self.notificationTitle.text = recObj.notificationTitle
                SegmentifyManager.sharedManager().sendWidgetView(instanceId: self.impressionId2!, interactionId: self.interactionId2!)
            }
        }
    }
    
    
    func setProductInfos(products : [ProductRecommendationModel]) {
        for product in products {
            self.productIds.append(product.productId!)
            self.titles.append(product.name!)
            self.images.append("https:" + product.image!)
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
    
    
    func setProductInfos2(products : [ProductRecommendationModel]) {
        for product in products {
            self.productIds2.append(product.productId!)
            self.titles2.append(product.name!)
            self.images2.append("https:" + product.image!)
            if product.category != nil {
                self.category2.append(product.category!)
            } else {
                self.category2.append("")
            }
            if product.price != nil {
                self.prices2.append(product.price!)
            } else {
                self.prices2.append(0)
            }
            self.brands2.append(product.brand!)
            if(product.oldPriceText != nil){
                self.oldPrices2.append(product.oldPriceText!)
            }
        }
        self.collecView.reloadData()
    }
    
    
    
    // send logout request
    @objc func logoutTapped(_ sender: Any) {
        let userObj = UserModel()
        userObj.username = "test"
        userObj.email = "test@segmentify.com"
        
        SegmentifyManager.sharedManager().sendUserLogout(segmentifyObject: userObj)
        
        performSegue(withIdentifier: "logoutShow", sender: nil)
    }
}

// table view functions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductCell", for: indexPath) as? HomeProductCell
        
        cell?.lblProductName.text = self.titles[indexPath.row]
        cell?.lblBrandName.text = self.brands[indexPath.row]
        cell?.lblPrice.text = String(self.prices[indexPath.row])
        //cell?.lblOldPrice.text = self.oldPrices[indexPath.row]
        
    
        let basketObj = BasketModel()
        basketObj.price = NSNumber(value : self.prices[indexPath.row])
        basketObj.productId = self.productIds[indexPath.row]
        basketObj.quantity = 1
        basketObj.step = "add"
        
        
        cell?.onButtonTapped = {
            SegmentifyManager.sharedManager().sendAddOrRemoveBasket(segmentifyObject: basketObj)
            
        }
        
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "productDetail" {
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
        
        if segue.identifier == "productDetailForCollec" {
            let destinationViewController = segue.destination as! ProductDetailViewController
            let cell = sender as! HomeCollectionViewCell
            let indexPath = self.collecView.indexPath(for: cell)
            destinationViewController.productName = self.titles2[(indexPath?.row)!]
            destinationViewController.productBrand = self.brands2[(indexPath?.row)!]
            destinationViewController.productPrice = "\(self.prices2[(indexPath?.row)!])"
            destinationViewController.image = self.images2[(indexPath?.row)!]
            destinationViewController.productID = self.productIds2[(indexPath?.row)!]
            destinationViewController.productCategory = self.category2[(indexPath?.row)!]
            destinationViewController.interactionId = self.interactionId
            destinationViewController.impressionId = self.impressionId
            
        }
        // TODO ‼️
//        if segue.identifier == "goToBasket" {
//            var indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
//            let destinationViewController = segue.destination as? BasketDetailViewController
//            
//            destinationViewController?.productName = self.titles[indexPath.row]
//            destinationViewController?.productBrand = self.brands[indexPath.row]
//            destinationViewController?.productPrice = NSNumber(value: Int(self.prices[indexPath.row]))
//            destinationViewController?.image = self.images[indexPath.row]
//            destinationViewController?.productID = self.productIds[indexPath.row]
//        }
        
    }
}

// collection view functions
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        cell?.lblProductName.text = self.titles2[indexPath.row]
        cell?.lblProductPrice.text = "\(self.prices2[indexPath.row])"
        
        if let imageURL = URL(string:  self.images2[indexPath.row]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell?.collecImage.image = image
                    }
                }
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        
        headerView.backgroundColor = UIColor.blue
        return headerView
    }
}


