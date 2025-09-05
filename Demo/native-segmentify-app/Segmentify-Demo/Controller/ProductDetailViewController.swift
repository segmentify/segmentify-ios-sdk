//
//  ProductDetailViewController.swift
//  Segmentify-Demo


import UIKit
import Segmentify

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationTitle: UILabel!
    
    var recommendations : [RecommendationModel] = []
    var tableViewProducts = [Product]()
    var productDetailItem = Product()
    var internalBannerViewArray = [InternalBannerModel]()
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
        sendBannerViewRequest()
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
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    func sendProductViewRequest() {
        let prodViewObj = ProductModel()
        prodViewObj.productId = self.productDetailItem.productId
        prodViewObj.name = self.productDetailItem.name
        prodViewObj.url = self.productDetailItem.url
        prodViewObj.lang = "EN"
        prodViewObj.inStock = true
        prodViewObj.image = self.productDetailItem.image?.replacingOccurrences(of: "https:", with: "")
        prodViewObj.category = self.productDetailItem.category?.last
        prodViewObj.price = self.productDetailItem.price
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
    
    // send banner view request
    func sendBannerViewRequest() {
        let bannerGroupViewModel = BannerGroupViewModel()
        bannerGroupViewModel.group = "Product Page Slider"
        let internalBannerModel = InternalBannerModel()
        internalBannerModel.title = "Gorgeous Duo T-Shirt & Trousers - From Product Page"
        internalBannerModel.order = 1
        internalBannerModel.image = "https://cdn.segmentify.com/demo/banner-img2.jpg"
        internalBannerModel.urls = ["https://www.example.com/gorgeous-duo-tshirt-trousers"]
        
        self.internalBannerViewArray.append(internalBannerModel)
        
        let internalBannerModel2 = InternalBannerModel()
        internalBannerModel2.title = "Ready to Renew  - From Product Page"
        internalBannerModel2.order = 2
        internalBannerModel2.image = "https://cdn.segmentify.com/demo/banner-img1.jpg"
        internalBannerModel2.urls = ["https://www.example.com/ready-to-renew"]
        self.internalBannerViewArray.append(internalBannerModel2)
        
        bannerGroupViewModel.banners = self.internalBannerViewArray
        SegmentifyManager.sharedManager().sendInternalBannerGroupEvent(segmentifyObject: bannerGroupViewModel)
        SegmentifyManager.sharedManager().sendBannerGroupViewEvent(segmentifyObject: bannerGroupViewModel)
        
        let bannerImpressionOperationModel = BannerOperationsModel()
        bannerImpressionOperationModel.type = "impression"
        bannerImpressionOperationModel.title = "Gorgeous Duo T-Shirt & Trousers - From Product Page"
        bannerImpressionOperationModel.group = "Product Page Slider"
        bannerImpressionOperationModel.order = 1
        
        let bannerImpressionOperationModel2 = BannerOperationsModel()
        bannerImpressionOperationModel2.type = "impression"
        bannerImpressionOperationModel2.title = "Ready to Renew - From Product Page"
        bannerImpressionOperationModel2.group = "Product Page Slider"
        bannerImpressionOperationModel2.order = 2
        
        SegmentifyManager.sharedManager().sendBannerImpressionEvent(segmentifyObject: bannerImpressionOperationModel)
        SegmentifyManager.sharedManager().sendBannerImpressionEvent(segmentifyObject: bannerImpressionOperationModel2)
        
        
        let bannerClickOperationModel = BannerOperationsModel()
        bannerClickOperationModel.type = "click"
        bannerClickOperationModel.title = "Gorgeous Duo T-Shirt & Trousers - From Product Page"
        bannerClickOperationModel.group = "Product Page Slider"
        bannerClickOperationModel.order = 1
        
        let bannerClickOperationModel2 = BannerOperationsModel()
        bannerClickOperationModel2.type = "click"
        bannerClickOperationModel2.title = "Ready to Renew - From Product Page"
        bannerClickOperationModel2.group = "Product Page Slider"
        bannerClickOperationModel2.order = 2
        
        SegmentifyManager.sharedManager().sendBannerClickEvent(segmentifyObject: bannerClickOperationModel)
        SegmentifyManager.sharedManager().sendBannerClickEvent(segmentifyObject: bannerClickOperationModel2)
        
        
        let bannerUpdateOperationModel = BannerOperationsModel()
        bannerUpdateOperationModel.type = "update"
        bannerUpdateOperationModel.title = "Ready to Renew - From Product Page"
        bannerUpdateOperationModel.group = "Product Page Slider"
        bannerUpdateOperationModel.order = 3
        SegmentifyManager.sharedManager().sendBannerUpdateEvent(segmentifyObject: bannerUpdateOperationModel);
        
        
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
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
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
            tableView.reloadData()
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
            self.notificationTitle.text = recObj.notificationTitle
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

