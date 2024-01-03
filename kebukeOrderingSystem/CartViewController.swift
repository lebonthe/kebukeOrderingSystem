//
//  CartViewController.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/27.
//

import UIKit

class CartViewController: UIViewController {

    // 與 storyboard 中的 UITableView 和 UILabel 連接
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // 當視圖控制器的視圖加載完畢時調用
    override func viewDidLoad() {
        super.viewDidLoad()

        // 計算購物車中總數量和總金額
        let totalItems = drinkCount
        var totalPrice = 0
        for item in cartList {
            if let priceInt = Int(item.price.replacingOccurrences(of: "$", with: "")){
                totalPrice += priceInt * item.count
            }
        }
        // 設置底部標籤的文字，顯示總數量和總金額
        bottomLabel.text = "共\(totalItems)杯飲料， \(totalPrice)元"
    }

    // 當視圖控制器的視圖即將消失時調用
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 檢查視圖是否正在被關閉
        if isBeingDismissed || isMovingFromParent {
            // 執行 Unwind Segue，回到之前的視圖控制器
            performSegue(withIdentifier: "unwindSegueToDetailViewController", sender: self)
        }
    }

    // 當視圖控制器的視圖即將出現時調用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 更新總數量和底部標籤
        updateTotalDrinkCountAndLabel()
        // 重新加載 tableView 數據
        tableView.reloadData()
    }

    // 按下提交訂單按鈕時調用
    @IBAction func sendOrder(_ sender: Any) {
        // 假設 userName 為已定義且有效的用戶名
        let userName = userName

        // 將購物車清單轉換為 UploadDrink 陣列以準備上傳
        let records = cartList.map { Record(fields: UploadDrink(userName: userName, name: $0.name, size: $0.size, sweet: $0.sweet, ice: $0.ice,topping: $0.topping, count: $0.count,price: $0.price, totalPrice: $0.totalPrice)) }
        let order = UploadOrder(records: records)

        // 將訂單編碼為 JSON
        do {
            let jsonData = try JSONEncoder().encode(order)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            // 將訂單數據發送到伺服器
            sendOrderToServer(jsonData: jsonData)
            // 顯示訂單提交成功的提示
            let controller = UIAlertController(title: "訂單已提交", message: "請於2024/1/4 19:00 至\n松江路 131 號 7 樓領取", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            controller.addAction(okAction)
            present(controller, animated: true)
        } catch {
            print("編碼錯誤: \(error)")
        }
        // 清空購物車，重置總數量和底部標籤
        cartList.removeAll()
        updateTotalDrinkCountAndLabel()
        drinkCount = 0 // 重置 drinkCount 為 0
    }
    
    // 將訂單數據發送到伺服器的方法
    func sendOrderToServer(jsonData: Data) {
        // 設定 API 的 URL
        let url = URL(string: "https://api.airtable.com/v0/appydWW9bHuuV62CI/drinks")!
        // 創建一個 URLRequest 物件
        var request = URLRequest(url: url)
        // 設定request header 的 authorization token
        request.setValue(APIKey.default, forHTTPHeaderField: "Authorization")
        // 設定請求方法為 POST
        request.httpMethod = "POST"
        // 設定內容類型為 JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 設定請求體為 JSON 數據
        request.httpBody = jsonData

        // 發起網路請求
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 如果請求成功，並能將回應數據轉換為字符串
            if let data, let content = String(data: data, encoding: .utf8) {
                // 打印回應的内容
                print(content)
            }
        }.resume() // 啟動請求任務
    }


    // 更新總數量和底部標籤的方法
    private func updateTotalDrinkCountAndLabel() {
        var totalItems = 0
        var totalPrice = 0

        for item in cartList {
            totalItems += item.count
            if let priceInt = Int(item.price.replacingOccurrences(of: "$", with: "")) {
                totalPrice += priceInt * item.count
            }
        }

        drinkCount = totalItems
        bottomLabel.text = "共\(totalItems)杯飲料，共\(totalPrice)元"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CartViewController: UITableViewDataSource {
    // 設定 tableView 的行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 打印目前購物車清單的數量
        print("cartList目前\(cartList.count) count")
        // 返回 cartList 的項目數量
        return cartList.count
    }
    
    // 設定每行的 cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 重用並取得 CartTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CartTableViewCell.self)", for: indexPath) as! CartTableViewCell

        // 獲取對應位置的購物車項目
        let cartItem = cartList[indexPath.row]
        // 設定 cell 的各項數據
        cell.picImageView.kf.setImage(with: cartItem.picUrl, placeholder: UIImage(systemName: "photo")) // 圖片
        cell.nameLabel.text = cartItem.name // 商品名稱
        cell.sizeLabel.text = cartItem.size // 尺寸
        cell.sweetLabel.text = cartItem.sweet // 甜度
        cell.iceLabel.text = cartItem.ice // 冰塊
        cell.toppingLabel.text = cartItem.topping // 加料
        cell.priceLabel.text = cartItem.price // 價格
        cell.countLabel.text = String("\(cartItem.count) 杯") // 數量
        if let priceInt = Int(cartItem.price.replacingOccurrences(of: "$", with: "")) {
            cell.totalPriceLabel.text = String(priceInt * cartItem.count) // 總價
        }
        cell.stepper.value = Double(cartItem.count) // 設定步進器的值
        cell.delegate = self // 設定代理
        return cell
    }
}

extension CartViewController: CartTableViewCellDelegate {
    // 當 cell 中的 stepper 數量發生變化時被調用
    func cartTableViewCell(_ cell: CartTableViewCell, didUpdateQuantity quantity: Int) {
        // 確定 cell 對應的 indexPath
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        if quantity == 0 {
            // 如果數量為 0，從 cartList 中移除該項目
            cartList.remove(at: indexPath.row)
        }

        // 更新購物車總數量和底部標籤
        updateTotalDrinkCountAndLabel()
        // 重新加載 tableView 以更新顯示
        tableView.reloadData()
    }
}



    



