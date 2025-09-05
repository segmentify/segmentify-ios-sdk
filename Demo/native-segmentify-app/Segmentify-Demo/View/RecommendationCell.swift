//
//  RecommendationCell.swift
//  Segmentify-Demo

import UIKit

class RecommendationCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblproductName: UILabel!
    @IBOutlet weak var lblproductBrand: UILabel!
    @IBOutlet weak var lblproductPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
