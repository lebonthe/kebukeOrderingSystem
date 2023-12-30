//
//  ListTableViewCell.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/28.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLable: UILabel!
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sweetLabel: UILabel!
    
    @IBOutlet weak var iceLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var toppingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
