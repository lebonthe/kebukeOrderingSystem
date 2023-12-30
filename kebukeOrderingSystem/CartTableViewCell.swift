//
//  CartTableViewCell.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/27.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    // 定義介面元件
    @IBOutlet weak var picImageView: UIImageView! // 用於顯示商品圖片的圖像視圖
    @IBOutlet weak var nameLabel: UILabel! // 用於顯示商品名稱的標籤
    @IBOutlet weak var sizeLabel: UILabel! // 用於顯示杯型的標籤
    @IBOutlet weak var sweetLabel: UILabel! // 用於顯示甜度選擇的標籤
    @IBOutlet weak var iceLabel: UILabel! // 用於顯示冰塊量的標籤
    @IBOutlet weak var countLabel: UILabel! // 用於顯示商品數量的標籤
    @IBOutlet weak var toppingLabel: UILabel! // 用於顯示加料選擇的標籤
    @IBOutlet weak var priceLabel: UILabel! // 用於顯示單價的標籤
    @IBOutlet weak var totalPriceLabel: UILabel! // 用於顯示總價的標籤
    @IBOutlet weak var stepper: UIStepper! // 用於調整商品數量的步進控制器
    
    weak var delegate: CartTableViewCellDelegate? // 設定代理，用於處理數量更新的動作

    override func awakeFromNib() {
        super.awakeFromNib()
        // 初始化代碼
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 配置選中狀態的視圖
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        // 當步進控制器的值改變時觸發
        delegate?.cartTableViewCell(self, didUpdateQuantity: Int(sender.value))
        // 通知代理當前單元格的數量已經更新
    }
}

protocol CartTableViewCellDelegate: AnyObject {
    // 定義代理協議，用於處理數量更新事件
    func cartTableViewCell(_ cell: CartTableViewCell, didUpdateQuantity quantity: Int)
}

