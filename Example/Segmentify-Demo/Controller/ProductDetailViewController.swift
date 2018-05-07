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
    var tableViewProducts = [Product]()
    var productDetailItem = Product()
    @IBOutlet weak var addToBasketButton: UIButton!
    
    var instanceId = String()
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductBrand: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToBasketButton.layer.cornerRadius = 7
        lblProductName.text = self.productDetailItem.name
        lblProductBrand.text = self.productDetailItem.brand
        lblProductPrice.text = "€ \(self.productDetailItem.price!)"
        sendPageViewRequest()
        sendProductViewRequest()
        sendClickEvent()
        loadImage()
    }
    
    
    func sendClickEvent(){
        SegmentifyManager.sharedManager().sendClickView(instanceId: self.instanceId, interactionId: productDetailItem.productId!)
    }

    
    func sendPageViewRequest() {
        let pageViewObj = PageModel()
        pageViewObj.category = "Product Page"
        pageViewObj.lang = "EN"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
        
        }
    }
    
    func sendProductViewRequest() {
        let prodViewObj = ProductModel()
        prodViewObj.productId = self.productDetailItem.productId
        prodViewObj.name = self.productDetailItem.name
        prodViewObj.url = self.productDetailItem.url
        prodViewObj.lang = "EN"
        prodViewObj.image = self.productDetailItem.image?.replacingOccurrences(of: "https:", with: "")
        prodViewObj.category = self.productDetailItem.category
        prodViewObj.price = self.productDetailItem.price
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
        basketObj.price = self.productDetailItem.price
        basketObj.productId = self.productDetailItem.productId
        basketObj.quantity = 1
        basketObj.step = "add"
        
        // send request
        SegmentifyManager.sharedManager().sendAddOrRemoveBasket(segmentifyObject: basketObj)
    }
    
    @IBAction func addToBasketBUtton(_ sender: UIButton) {
        
        sendAddToBasketRequest()
    }
    
    // pass data another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "basketDetail" {
            let destinationViewController = segue.destination as? BasketDetailViewController
            //destinationViewController?.basketDetailItem = self.productDetailItem
            destinationViewController?.instanceId = self.instanceId
            // 👻
            if self.productDetailItem.count == 0 {
                BasketProducts.basketProducts.append(self.productDetailItem)
            }
            for product in BasketProducts.basketProducts {
                if product.productId == self.productDetailItem.productId {
                    product.count = product.count + 1
                }
            }
            
        }
       
        if segue.identifier == "productDetailForProductVC" {
            var indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let destinationViewController = segue.destination as? ProductDetailViewController
            destinationViewController?.productDetailItem = tableViewProducts[indexPath.row]
            destinationViewController?.instanceId = self.instanceId
        }
    }
    
    func loadImage() {
        if let imageURL = URL(string: productDetailItem.image!) {
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
            if nil == product.price {
                product.price = 0
            }
            if nil == product.oldPrice {
                product.oldPrice = 0
            }
            if nil == product.category {
                product.category = ""
            }
            let newProduct = Product(image: "https:" + product.image!, name: product.name, price: product.price, oldPrice: product.oldPrice as? Int, productId: product.productId, brand: product.brand, url: product.url, inStock: product.inStock, category: product.category, categories: product.categories)
            tableViewProducts.append(newProduct)
        }
        self.tableView.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            if recObj.instanceId == "ext_product_rec" {
                self.setProductInfos(products: recObj.products!)
                self.instanceId = recObj.instanceId!
                self.notificationTitle.text = recObj.notificationTitle
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
        return tableViewProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCell", for: indexPath) as? RecommendationCell
        
        cell?.lblproductName.text = tableViewProducts[indexPath.row].name
        cell?.lblproductBrand.text = tableViewProducts[indexPath.row].brand
        cell?.lblproductPrice.text = "€ \(tableViewProducts[indexPath.row].price!)"
    
        if let imgURL = URL(string: tableViewProducts[indexPath.row].image!) {
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
