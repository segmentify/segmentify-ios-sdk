//
//  PurchaseSuccessViewController.swift
//  Segmentify-Demo


import UIKit
import Segmentify

class PurchaseSuccessViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var recommendations: [RecommendationModel] = []
    var tableViewProducts = [Product]()
    var OrderDetailItem = Product()
    var instanceId = String()
    var productsArray = [Any]()
    @IBOutlet weak var lblorderNo: UILabel!
    var orderNo = Int()
    var totalPrice = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        //loadImage()
        lblorderNo.text = """
        Purchase Completed 🎉
        
        Order No: \(orderNo)
        Total Price: €  \(totalPrice)
        """
        sendPageViewRequest()
        sendPurchaseRequest()
        BasketProducts.basketProducts = []
    }
    
    func sendPageViewRequest() {
        let pageObj = PageModel()
        pageObj.category = "Purchase Success Page"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    func sendPurchaseRequest() {
        let purchObj = CheckoutModel()
        for prod in BasketProducts.basketProducts {
            let product = ["price": "\(prod.price!)", "productId": "\(prod.productId!)", "quantity": "\(prod.count!)"]
            self.productsArray.append(product)
        }
        purchObj.productList = productsArray
        purchObj.totalPrice = self.totalPrice as NSNumber
        purchObj.orderNo = "\(orderNo)"
        
        
        SegmentifyManager.sharedManager().sendPurchase(segmentifyObject: purchObj) { (response: [RecommendationModel]) in
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
            tableViewProducts.append(newProduct)
        }
        self.tableView.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            self.setProductInfos(products: recObj.products!)
            self.instanceId = recObj.instanceId!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailForPurchaseVC" {
            var indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            
            let destinationViewController = segue.destination as? ProductDetailViewController
            destinationViewController?.productDetailItem = tableViewProducts[indexPath.row]
            destinationViewController?.instanceId = self.instanceId
        }
    }

    @IBAction func doneButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension PurchaseSuccessViewController: UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRecommendationCell", for: indexPath) as? OrderRecommendationCell
        
        cell?.lblProductName.text = tableViewProducts[indexPath.row].name
        cell?.lblProductBrand.text = tableViewProducts[indexPath.row].brand
        cell?.lblProductPrice.text = "€ \(tableViewProducts[indexPath.row].price!)"
    
        if let imageURL = URL(string:  tableViewProducts[indexPath.row].image!) {
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
