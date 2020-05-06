//
//  HomeProductCell.swift
//  Segmentify-Demo

import UIKit
import Segmentify

class HomeProductCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var basketButton: UIButton!
    
    var onButtonTapped : (() -> Void)? = nil
    
    @IBAction func addToBasket(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        basketButton.layer.cornerRadius = 7
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
