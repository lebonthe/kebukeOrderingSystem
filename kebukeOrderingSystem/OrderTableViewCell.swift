//
//  OrderTableViewCell.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/26.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    // 飲品圖片
    @IBOutlet weak var photoImageView: UIImageView!
    // 飲品名稱
    @IBOutlet weak var drinkNameLabel: UILabel!
    // 點選 cell 的滿版 button
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
