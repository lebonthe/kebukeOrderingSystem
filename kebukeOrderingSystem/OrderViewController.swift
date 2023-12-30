//
//  OrderViewController.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/25.
//

import UIKit
import Kingfisher
class OrderViewController: UIViewController {
    // 類別 segmentedControl
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    // 定義一個 UIView 實例作為 categorySegmentedControl 的底部線條
    var bottomLine = UIView()
//    // 定義儲存使用者名稱的變數
//    var userName:String = ""
    // 顯示使用者名稱的 UILabel
    @IBOutlet weak var userNameLabel: UILabel!
    // 連接表格的 IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // 初始化一個用來儲存 Drink 型別內容的空陣列 drinkMenu
    var drinkMenu = [Drink]()
    
    @IBOutlet weak var cartButton: UIButton!
    
// @IBOutlet weak var waintingActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 將 EnteringViewController 傳來的使用者名稱與問候句顯示
        userNameLabel.text = "嗨！\(userName)，今天想喝點什麼？"
        // 設定底部線條的背景顏色
        bottomLine.backgroundColor = UIColor(red: 0.714, green: 0.588, blue: 0.392, alpha: 1)
        // 設定底部線條不要使用 autoresizing mask 轉換成約束
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        // 將底部線條加到當前視圖控制器的視圖上
        view.addSubview(bottomLine)

        // 使用 NSLayoutConstraint 來為底部線條設定約束，確保它的位置和大小正確
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor), // 線條頂部對齊分段控制的底部
            bottomLine.heightAnchor.constraint(equalToConstant: 2), // 線條高度為2
            bottomLine.widthAnchor.constraint(equalTo: categorySegmentedControl.widthAnchor, multiplier: 1 / CGFloat(categorySegmentedControl.numberOfSegments)), // 寬度等於分段控制寬度的一部分
            bottomLine.leftAnchor.constraint(equalTo: categorySegmentedControl.leftAnchor) // 左邊對齊分段控制的左邊
        ])

        // 移除預設框線
        categorySegmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        categorySegmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
       fetchItems(category: "季節限定")
//        
//        DispatchQueue.main.async {
//            self.cartButton.setTitle("\(drinkCount)", for: .normal)
//        }
    }
    
    // 當分段控制器的選擇項目發生改變時會被呼叫
    @IBAction func categorySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let drinkCategory = ChosenCategory(rawValue: sender.selectedSegmentIndex)!
        switch drinkCategory {
        case .單品茶:
            fetchItems(category: "單品茶 Classic")
        case .調茶:
            fetchItems(category: "調茶 Mix tea")
        case .雲蓋:
            fetchItems(category: "雲蓋 Sweet Cream Cold Foam")
        case .歐蕾:
            fetchItems(category: "歐蕾 Milk tea")
        default:
            fetchItems(category: "季節限定")
        }
        // 使用 UIView 的動畫函數來創建一個動畫效果，動畫的持續時間為 0.3 秒。
        UIView.animate(withDuration: 0.3) {
            // 計算底部線條的新的 x 座標位置，將分段控制器的寬度除以段數，再乘以當前選擇的分段索引，得出底線應該移動到的新位置。
            self.bottomLine.frame.origin.x = self.categorySegmentedControl.frame.width / CGFloat(self.categorySegmentedControl.numberOfSegments) * CGFloat(self.categorySegmentedControl.selectedSegmentIndex) + self.categorySegmentedControl.frame.minX
        }
    }
    func fetchItems(category: String) {
        // 設定 JSON 數據的 URL
        let urlStr = "https://raw.githubusercontent.com/lebonthe/JSON_API/main/kebukeMenu.json"
        // 嘗試將字符串轉換成 URL
        if let url = URL(string: urlStr) {
            // 使用 URLSession 創建一個數據任務來加載和獲取數據
            URLSession.shared.dataTask(with: url) { data, response, error in
                // 檢查返回的數據是否存在
                if let data = data {
                    // 創建一個 JSON 解碼器
                    let decoder = JSONDecoder()
                    do {
                        // 嘗試將數據解碼為 Category 類型的數組
                        let categories = try decoder.decode([Category].self, from: data)
                        // 尋找匹配指定類別名稱的項目
                        if let selectedCategory = categories.first(where: { $0.category == category }) {
                            // 更新 drinkMenu 為選中類別的飲料列表
                            self.drinkMenu = selectedCategory.drinks ?? []
                        }
                        // 在主線程上重新加載表格視圖
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch {
                        // 打印解碼過程中的任何錯誤
                        print(error)
                    }
                } else {
                    // 打印加載過程中的任何錯誤
                    print(error ?? "Unknown error")
                }
            }.resume() // 啟動數據任務
        }
    }

    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailViewController? {
        // 檢查當前選擇的表格視圖行，並獲取它的索引
        if let row = tableView.indexPathForSelectedRow?.row {
            // 使用 UIStoryboard 的編碼器 (coder) 創建 DetailViewController 的實例
            let controller = DetailViewController(coder: coder)
            // 將選擇的飲料信息賦值給 DetailViewController 的 drink 屬性
            controller?.drink = drinkMenu[row]
            // 返回 DetailViewController 的實例
            return controller
        } else {
            // 如果沒有選擇的行，則返回 nil，不執行跳轉
            return nil
        }
    }

    

    // 在 view 即將顯示在螢幕上時被調用
    override func viewWillAppear(_ animated: Bool) {
        // 調用父類的同名方法，這是一個好習慣，以確保父類的功能也被執行。
        super.viewWillAppear(animated)

        // 調用自定義的 updateDrinkCount 函數來更新 drinkCount 變量。
        // 此函數計算 cartList 中所有項目的總數量。
        updateDrinkCount()

        // 更新購物車按鈕(cartButton)的標題以顯示最新的 drinkCount 值。
        // 這樣用戶可以看到當前購物車中有多少飲料。
        cartButton.setTitle("\(drinkCount)", for: .normal)
    }

    // 更新 drinkCount 變量，它表示購物車中的總飲料數量
    func updateDrinkCount() {
        // 使用 reduce 函數計算 cartList 中所有 CartList 對象的 count 屬性之和。
        // $0 是累加器（初始值為 0），$1 是當前迭代的 CartList 對象。
        // 結果是所有 CartList 對象的 count 值之和，這個總和被賦值給 drinkCount。
        drinkCount = cartList.reduce(0) { $0 + $1.count }
    }

    // 此函數是一個 UIStoryboardSegue 的準備動作，它在轉場到 CartViewController 之前被調用。
    @IBSegueAction func showCart(_ coder: NSCoder) -> CartViewController? {
        // 使用指定的編碼器（coder）創建 CartViewController 的實例。
        let controller = CartViewController(coder: coder)

        // 返回創建的 CartViewController 實例。
        return controller
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

extension OrderViewController: UITableViewDataSource {
    // 決定表格的行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkMenu.count // 將行數設為 drinkMenu 的數量
    }
    
    // 為每一行提供一個單元格，在表格視圖需要渲染每一行時被呼叫
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 從 tableView 的重用池中取得一個單元格，如果沒有可重用的，則創建新的
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
        // 根據當前行的索引從 drinkMenu 獲取對應的飲料資訊
        let item = drinkMenu[indexPath.row]
        
            // 設定 cell 的主要文本標籤為飲料的名稱
            cell.drinkNameLabel.text = item.name
            cell.photoImageView.kf.setImage(with: item.picUrl,placeholder: UIImage(systemName: "photo"))
        
        return cell
    }
}

