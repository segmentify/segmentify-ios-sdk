//
//  CategoryViewController.swift
//  Segmentify-Demo

import UIKit
import Segmentify

class CategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var recommendations: [RecommendationModel] = []
    var tableViewProducts = [Product]()
    var instanceId = String()
    var buttonIndex = Int()
    var currentProduct = Product()

    override func viewDidLoad() {
        super.viewDidLoad()
        sendPageViewRequest()
    }
    
    // send page view request
    func sendPageViewRequest() {
        let pageViewObj = PageModel()
        pageViewObj.category = "Category Page"
        pageViewObj.subCategory = "Womenswear"
        pageViewObj.region = "TURKEY"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            if recObj.instanceId == "ext_category_rec" {
                self.setProductInfosTableView(products: recObj.products!)
                self.instanceId = recObj.instanceId!
                SegmentifyManager.sharedManager().sendWidgetView(instanceId: recObj.instanceId!, interactionId: recObj.interactionId!)
            }
        }
    }
    
    func setProductInfosTableView(products : [ProductRecommendationModel]) {
        for product in products {
            if nil == product.price {
                product.price = 0
            }
            if nil == product.oldPrice {
                product.oldPrice = 0
            }
            if nil == product.category {
                product.category = []
            }
            let newProduct = Product(image: "https:" + product.image!, name: product.name, price: product.price, oldPrice: product.oldPrice as? Int, productId: product.productId, brand: product.brand, url: product.url, inStock: product.inStock, category: product.category, categories: product.categories)
            tableViewProducts.append(newProduct)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryToBasket" {
            let destinationViewController = segue.destination as? BasketDetailViewController
            destinationViewController?.instanceId = self.instanceId
            
        }
        if segue.identifier == "CategoryToProduct" {
            if let indexPath: IndexPath = self.tableView.indexPathForSelectedRow {
                let currentProduct = tableViewProducts[indexPath.row]
                self.currentProduct = currentProduct
            }
            
            let destinationViewController = segue.destination as? ProductDetailViewController
            destinationViewController?.productDetailItem = currentProduct
            destinationViewController?.instanceId = self.instanceId
        }
    }
    
    @IBAction func returnHome(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell

        cell?.lblProductName.text = tableViewProducts[indexPath.row].name
        cell?.lblBrandName.text = tableViewProducts[indexPath.row].brand
        cell?.lblPrice.text = "€ \(tableViewProducts[indexPath.row].price!)"
        cell?.basketButton.tag = indexPath.row
        
        let basketObj = BasketModel()
        basketObj.price = tableViewProducts[indexPath.row].price
        basketObj.productId = tableViewProducts[indexPath.row].productId
        basketObj.quantity = 1
        basketObj.step = "add"
        
        cell?.onButtonTapped = {
            // set tapped button's tag to buttonIndex variable
            self.buttonIndex = (cell?.basketButton.tag)!
            //BasketProducts.basketProducts.append(self.tableViewProducts[self.buttonIndex])
            
            if self.tableViewProducts[self.buttonIndex].count == 0 {
                BasketProducts.basketProducts.append(self.tableViewProducts[self.buttonIndex])
            }
            for product in BasketProducts.basketProducts {
                if product.productId == self.tableViewProducts[self.buttonIndex].productId {
                    product.count = product.count + 1
                }
            }
            
            SegmentifyManager.sharedManager().sendAddOrRemoveBasket(segmentifyObject: basketObj)
        }

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

