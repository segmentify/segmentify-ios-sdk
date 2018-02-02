//
//  OrderRecommendationCell.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 29.01.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit

class OrderRecommendationCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductBrand: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
