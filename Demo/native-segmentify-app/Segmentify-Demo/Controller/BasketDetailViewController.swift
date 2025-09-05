//
//  BasketDetailViewController.swift
//  Segmentify-Demo

import UIKit
import Segmentify

class BasketDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collecView: UICollectionView!
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var notificationTitle: UILabel!
    
    var recommendations : [RecommendationModel] = []
    var basketDetailItem = Product()
    var collecViewProducts = [Product]()
    
    var instanceId: String?
    var orderNoRandom: Int = 0
    var totalOrderPrice : Double?
    
    var productsArray = [Any]()
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if BasketProducts.basketProducts.count == 0 {
            purchaseButton.isEnabled = false
        }
        orderNoRandom = Int(arc4random_uniform(10000000)+1)
        // set corner radius to purchase button
        purchaseButton.layer.cornerRadius = 7
        setTotalPrice()
        sendPageViewRequest()
        sendCheckoutRequest()
    }
    
    // calculate total amount of items
    func calculateTotalPrice() -> Double {
        var total: Double = 0.0
        for product in BasketProducts.basketProducts {
            total = total + (product.price?.doubleValue)! * Double(product.count!)
        }
        return total
    }
    
    // set total price to totalPrice label
    func setTotalPrice() {
        totalOrderPrice = calculateTotalPrice()
        totalPrice.text = "Total amount of items: €\(totalOrderPrice!)"
    }
    
    func sendPageViewRequest() {
        let pageViewObj = PageModel()
        pageViewObj.category = "Basket Page"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    func sendCheckoutRequest() {
        let checkObj = CheckoutModel()
        for prod in BasketProducts.basketProducts {
            let product = ["price": "\(prod.price!)", "productId": "\(prod.productId!)", "quantity": "\(prod.count!)"]
            self.productsArray.append(product)
        }
        checkObj.productList = productsArray
        checkObj.totalPrice = NSNumber(value: calculateTotalPrice())
        checkObj.orderNo = "\(orderNoRandom)"

        SegmentifyManager.sharedManager().sendViewBasket(segmentifyObject: checkObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
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
                product.category = []
            }
            let newProduct = Product(image: "https:" + product.image!, name: product.name, price: product.price, oldPrice: product.oldPrice as? Int, productId: product.productId, brand: product.brand, url: product.url, inStock: product.inStock, category: product.category, categories: product.categories)
            collecViewProducts.append(newProduct)
        }
        self.collecView.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            self.setProductInfos(products: recObj.products!)
            self.notificationTitle.text = recObj.notificationTitle
            self.instanceId = recObj.instanceId
        }
    }
    
    // pass data another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailForBasketVC" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let destinationViewController = segue.destination as? ProductDetailViewController
            destinationViewController?.productDetailItem = BasketProducts.basketProducts[indexPath.row]
            destinationViewController?.instanceId = self.instanceId!
        }
        if segue.identifier == "goToOrderDetail" {
            let destinationViewController = segue.destination as? PurchaseSuccessViewController
            destinationViewController?.totalPrice = self.totalOrderPrice!
            destinationViewController?.orderNo = self.orderNoRandom
            destinationViewController?.instanceId = self.instanceId!
        }
        if segue.identifier == "productDetailForBasketReco" {
            let destinationViewController = segue.destination as! ProductDetailViewController
            let cell = sender as! BasketRecommendationCell
            let indexPath = self.collecView.indexPath(for: cell)
            destinationViewController.productDetailItem = collecViewProducts[(indexPath?.row)!]
            destinationViewController.instanceId = self.instanceId!
        }
        
    }
    
    @IBAction func returnHome(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
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
        return BasketProducts.basketProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketProductCell", for: indexPath) as? BasketProductCell
    
            cell?.lblProductName.text = BasketProducts.basketProducts[indexPath.row].name
            cell?.lblProductBrand.text = BasketProducts.basketProducts[indexPath.row].brand
            cell?.lblProductPrice.text = "€ \(BasketProducts.basketProducts[indexPath.row].price!)"
            cell?.lblProductCount.text = "Piece: \(BasketProducts.basketProducts[indexPath.row].count!)"
            
            if let imageURL = URL(string: BasketProducts.basketProducts[indexPath.row].image!) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell?.productImage.image = image
                        }
                    }
                }
            }
        return cell!
    }
    
    // delete row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        BasketProducts.basketProducts.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        setTotalPrice()
        if BasketProducts.basketProducts.count == 0 {
            purchaseButton.isEnabled = false
        }
    }
}

extension BasketDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collecViewProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketRecommendationCell", for: indexPath) as? BasketRecommendationCell
        cell?.lblProductName.text = collecViewProducts[indexPath.row].name
        cell?.lblProductPrice.text = "€ \(collecViewProducts[indexPath.row].price!)"

        if let imageURL = URL(string:  collecViewProducts[indexPath.row].image!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell?.productImg.image = image
                    }
                }
            }
        }
        return cell!
    }
}

