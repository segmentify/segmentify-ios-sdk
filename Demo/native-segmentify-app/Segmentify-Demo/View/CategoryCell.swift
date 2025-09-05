//
//  CategoryCell.swift
//  Segmentify-Demo

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
