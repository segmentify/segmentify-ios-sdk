//
//  PurchaseSuccessViewController.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 19.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import UIKit

class PurchaseSuccessViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var price2Label: UILabel!
    @IBOutlet weak var name2Label: UILabel!
    @IBOutlet weak var price1Label: UILabel!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    
    var images : [String] = []
    var names : [String] = []
    var titles : [String] = []
    var prices : [Int] = []
    var oldPrices : [String] = []
    var productIds : [String] = []
    
    var recommendations : [RecommendationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendPageViewEvent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func sendPageViewEvent() {
        
         SegmentifyManager.config(appkey: Constant.segmentifyAppKey, dataCenterUrl: Constant.segmentifyDataCenterUrl, subDomain: Constant.segmentifySubDomain)
        
        let obj = SegmentifyObject()
        //obj.category = "Search Page"
        //obj.subCategory = "Womenswear"
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: obj) { (response: [RecommendationModel]) in
            self.recommendations = response
            self.createProducts(recommendations: self.recommendations)
        }
    }
    
    func setProductInfos(products : [ProductRecommendationModel]) {
        for product in products {
            self.productIds.append(product.productId!)
            self.titles.append(product.name!)
            self.images.append("https:" + product.image!)
            self.prices.append(product.price!)
            if(product.oldPriceText != nil){
                self.oldPrices.append(product.oldPriceText!)
            }
        }
        self.tableview.reloadData()
    }
    
    func createProducts(recommendations : [RecommendationModel]) {
        for recObj in recommendations {
            if recObj.notificationTitle == "Deneme" {
                self.setProductInfos(products: recObj.products!)
            }
        }
    }
}

extension PurchaseSuccessViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.nameLabel.text = self.titles[indexPath.row]
        cell.priceLabel.text = String(self.prices[indexPath.row])
        cell.oldPriceLabel.text=String(self.oldPrices[indexPath.row])
        
        if let imageURL = URL(string:  self.images[indexPath.row]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgDeneme.image = image
                    }
                }
            }
        }
        return cell
    }
}

