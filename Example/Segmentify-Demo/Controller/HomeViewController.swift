//
//  ViewController.swift
//  Segmentify-Demo

import UIKit
import Firebase
import Segmentify

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var categoryTitle: UIButton!
    @IBOutlet weak var basketButton: UIBarButtonItem!
    
    var recommendations: [RecommendationModel] = []
    var response = SearchModel()
    var facetedResponse:FacetedResponseModel?
    var collectionViewProducts = [Product]()
    var tableViewProducts = [Product]()
    var sectionsArray = [Section]()
    var instanceId = String()
    var currentProduct = Product()
    var internalBannerViewArray = [InternalBannerModel]()
    // selected button's tag number
    var buttonIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // define logoutTapped function to left bar button
        let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(logoutTapped(_:)))
        navigationItem.leftBarButtonItem = leftButton
        // no large title
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        // pageView Request
        //sendPageViewRequest();
        sendSearchPageViewRequest()
        //sendBannerViewRequest()
        // update table view
        //sendSearchFacetedPageViewRequest()
        tableView.reloadData()
    }
    
    func sendSearchPageViewRequest() {
        let pageViewObj = SearchPageModel()
        pageViewObj.query = "query1"
        pageViewObj.lang = "TR"
        pageViewObj.region = "TURKEY"
        SegmentifyManager.sharedManager().sendSearchPageView(segmentifyObject: pageViewObj){
            (response: SearchModel) in
            self.response = response
        }
    }
    
    func sendSearchFacetedPageViewRequest() {
        let pageViewObj = SearchFacetPageModel()
        pageViewObj.query = "query"
        pageViewObj.lang = "TR"
        pageViewObj.region = "region-1"
        pageViewObj.trigger = "keyword"
        pageViewObj.type = "faceted"
        pageViewObj.ordering = FacetedOrdering()
        pageViewObj.ordering?.page = 1
        SegmentifyManager.sharedManager().sendFacetedSearchPageView(segmentifyObject: pageViewObj){
            (response: FacetedResponseModel) in
            self.facetedResponse = response
        }
    }
    
    // send page view request
    func sendPageViewRequest() {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
              let obj = NotificationModel()
              obj.deviceToken = token
              obj.type = NotificationType.PERMISSION_INFO
              obj.params = ["price": "123", "productId": "13", "quantity": "132"]
              obj.providerType = ProviderType.FIREBASE
              SegmentifyManager.sharedManager().sendNotification(segmentifyObject: obj)
          }
        }
        
        let pageViewObj = PageModel()
        pageViewObj.category = "Home Page"
        pageViewObj.params = ["homeMapLocation":"İstanbul/Kadıköy/19 Mayıs"] as [String : AnyObject]
        pageViewObj.testMode = false
        pageViewObj.region = "TURKEY"
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: pageViewObj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    // send banner view request
    func sendBannerViewRequest() {
        // Banner Group View Model
        let bannerGroupViewModel = BannerGroupViewModel()
        bannerGroupViewModel.group = "Home Page Slider"
        
        // optional parameters
        let internalBannerModel = InternalBannerModel()
        internalBannerModel.title = "Gorgeous Duo T-Shirt & Trousers"
        internalBannerModel.order = 1
        internalBannerModel.image = "https://cdn.segmentify.com/demo/banner-img2.jpg"
        internalBannerModel.urls = ["https://www.example.com/gorgeous-duo-tshirt-trousers"]
        
        self.internalBannerViewArray.append(internalBannerModel)
        
        let internalBannerModel2 = InternalBannerModel()
        internalBannerModel2.title = "Ready to Renew"
        internalBannerModel2.order = 2
        internalBannerModel2.image = "https://cdn.segmentify.com/demo/banner-img1.jpg"
        internalBannerModel2.urls = ["https://www.example.com/ready-to-renew"]
        self.internalBannerViewArray.append(internalBannerModel2)
        bannerGroupViewModel.banners = self.internalBannerViewArray
        // optional parameters end
        
        SegmentifyManager.sharedManager().sendInternalBannerGroupEvent(segmentifyObject: bannerGroupViewModel)
        SegmentifyManager.sharedManager().sendBannerGroupViewEvent(segmentifyObject: bannerGroupViewModel)
        
        let bannerImpressionOperationModel = BannerOperationsModel()
        bannerImpressionOperationModel.type = "impression"
        bannerImpressionOperationModel.title = "Gorgeous Duo T-Shirt & Trousers"
        bannerImpressionOperationModel.group = "Home Page Slider"
        bannerImpressionOperationModel.order = 1
        
        let bannerImpressionOperationModel2 = BannerOperationsModel()
        bannerImpressionOperationModel2.type = "impression"
        bannerImpressionOperationModel2.title = "Ready to Renew"
        bannerImpressionOperationModel2.group = "Home Page Slider"
        bannerImpressionOperationModel2.order = 2
        
        SegmentifyManager.sharedManager().sendBannerImpressionEvent(segmentifyObject: bannerImpressionOperationModel)
        SegmentifyManager.sharedManager().sendBannerImpressionEvent(segmentifyObject: bannerImpressionOperationModel2)
        
        
        let bannerClickOperationModel = BannerOperationsModel()
        bannerClickOperationModel.type = "click"
        bannerClickOperationModel.title = "Gorgeous Duo T-Shirt & Trousers"
        bannerClickOperationModel.group = "Home Page Slider"
        bannerClickOperationModel.order = 1
        
        let bannerClickOperationModel2 = BannerOperationsModel()
        bannerClickOperationModel2.type = "click"
        bannerClickOperationModel2.title = "Ready to Renew"
        bannerClickOperationModel2.group = "Home Page Slider"
        bannerClickOperationModel2.order = 2
        
        SegmentifyManager.sharedManager().sendBannerClickEvent(segmentifyObject: bannerClickOperationModel)
        SegmentifyManager.sharedManager().sendBannerClickEvent(segmentifyObject: bannerClickOperationModel2)
        
        
        let bannerUpdateOperationModel = BannerOperationsModel()
        bannerUpdateOperationModel.type = "update"
        bannerUpdateOperationModel.title = "Ready to Renew"
        bannerUpdateOperationModel.group = "Home Page Slider"
        bannerUpdateOperationModel.order = 3
        SegmentifyManager.sharedManager().sendBannerUpdateEvent(segmentifyObject: bannerUpdateOperationModel);
    }
    
    //
    func createProducts(recommendations : [RecommendationModel]) {
        self.setProductInfosTableView(products: [])
        for recObj in recommendations {
            self.setProductInfosTableView(products: recObj.products!)
            self.instanceId = recObj.instanceId!
            self.notificationTitle.text = recObj.notificationTitle
            SegmentifyManager.sharedManager().sendWidgetView(instanceId: recObj.instanceId!, interactionId: recObj.interactionId!)
        }
    }
    
    func setProductInfosTableView(products : [ProductRecommendationModel]) {
        let staticProduct = Product(image: "https://cdn.shopify.com/s/files/1/1524/5822/products/product_necklace_mariacalderara_anchor-necklace01_300x300.jpg?v=1475499408", name: "Necklace Mariacalderara", price: 775, oldPrice: 350, productId: "25800412873", brand: "Maria Calderara", url: "https://segmentify-shop.myshopify.com/products/anchor-necklace-no-color", inStock: true, category: ["Accessories"], categories: ["Accessories"])
        let staticProduct2 = Product(image: "https://cdn.shopify.com/s/files/1/1524/5822/products/20141215_Lana-1302_300x300.jpg?v=1475500812", name: "Babydoll Tank in White", price: 678, oldPrice: 100, productId: "25801129801", brand: "Pero", url: "https://segmentify-shop.myshopify.com/products/babydoll-tank-in-white", inStock: true, category: ["Accessories"], categories: ["Accessories"])
        let staticProduct3 = Product(image: "https://cdn.shopify.com/s/files/1/1524/5822/products/0810_lana_look01_43_300x300.jpg?v=1475498494", name: "Knit Hooded Jumpsuit in Black", price: 208, oldPrice: 0, productId: "25800126985", brand: "Album di Famiglia", url: "https://segmentify-shop.myshopify.com/products/ball-point-sock", inStock: true, category: ["Womenswear"], categories: ["Womenswear"])
        sectionsArray = [Section(sectionName: "Non-Recommendation Products", sectionObjects: [staticProduct,staticProduct2,staticProduct3])]
        //tableViewProducts.append(staticProduct)
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
        sectionsArray.append(Section(sectionName: "Recommendations Products", sectionObjects: tableViewProducts))
        self.tableView.reloadData()
    }
    
    func setProductInfosCollectionView(products : [ProductRecommendationModel]) {
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
            collectionViewProducts.append(newProduct)
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
        BasketProducts.basketProducts = []
    }
}

// table view functions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Weekly Products"
        }
        return "Recommendation Products"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.center
        if section == 0 {
            header.tintColor = UIColor(red:0.82, green:0.38, blue:0.57, alpha:1.0)
        } else if section == 1 {
            header.tintColor = UIColor(red:0.67, green:0.67, blue:0.81, alpha:1.0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionsArray[section].sectionObjects?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductCell", for: indexPath) as? HomeProductCell
        cell?.lblProductName.text = sectionsArray[indexPath.section].sectionObjects?[indexPath.row].name
        cell?.lblBrandName.text = sectionsArray[indexPath.section].sectionObjects![indexPath.row].brand
        cell?.lblPrice.text = "€ "+String(describing: sectionsArray[indexPath.section].sectionObjects![indexPath.row].price!)
        cell?.basketButton.tag = indexPath.row
        
        let basketObj = BasketModel()
        basketObj.price = sectionsArray[indexPath.section].sectionObjects![indexPath.row].price
        basketObj.productId = sectionsArray[indexPath.section].sectionObjects![indexPath.row].productId
        basketObj.quantity = 1
        basketObj.step = "add"
        
        cell?.onButtonTapped = {
            // set tapped button's tag to buttonIndex variable
            self.buttonIndex = (cell?.basketButton.tag)!
            if self.sectionsArray[indexPath.section].sectionObjects![self.buttonIndex].count == 0 {
                BasketProducts.basketProducts.append(self.sectionsArray[indexPath.section].sectionObjects![self.buttonIndex])
            }
            // 👻 self.tableViewProducts[self.buttonIndex]
            for product in BasketProducts.basketProducts {
                if product.productId == self.sectionsArray[indexPath.section].sectionObjects![self.buttonIndex].productId {
                    product.count = product.count + 1
                }
            }
            
            SegmentifyManager.sharedManager().sendAddOrRemoveBasket(segmentifyObject: basketObj)
        }
        
        if let imageURL = URL(string:  sectionsArray[indexPath.section].sectionObjects![indexPath.row].image!) {
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
            if let indexPath: IndexPath = self.tableView.indexPathForSelectedRow {
                let currentProduct = sectionsArray[indexPath.section].sectionObjects![indexPath.row]
                self.currentProduct = currentProduct
            }
            
            let destinationViewController = segue.destination as? ProductDetailViewController
            destinationViewController?.productDetailItem = currentProduct
            destinationViewController?.instanceId = self.instanceId
        }
        
        if segue.identifier == "productDetailForCollec" {
            let destinationViewController = segue.destination as! ProductDetailViewController
            let cell = sender as! HomeCollectionViewCell
            let indexPath = self.collecView.indexPath(for: cell)
            destinationViewController.productDetailItem = collectionViewProducts[(indexPath?.row)!]
            destinationViewController.instanceId = self.instanceId
            
        }
        
        if segue.identifier == "goToBasket" {
            //let indexPath: Int = buttonIndex
            let destinationViewController = segue.destination as? BasketDetailViewController
            //destinationViewController?.basketDetailItem = tableViewProducts[indexPath]
            //BasketProducts.basketProducts.append(tableViewProducts[indexPath])
            destinationViewController?.instanceId = self.instanceId
        }
        
    }
}

// collection view functions
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        cell?.lblProductName.text = collectionViewProducts[indexPath.row].name
        cell?.lblProductPrice.text = "€ \(collectionViewProducts[indexPath.row].price!)"
        
        if let imageURL = URL(string:  collectionViewProducts[indexPath.row].image!) {
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
}

