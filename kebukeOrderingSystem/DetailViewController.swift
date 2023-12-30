//
//  DetailViewController.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/27.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    // 飲料大圖
    @IBOutlet weak var bigImageView: UIImageView!
    // 品名 Label
    @IBOutlet weak var detailDrinkNameLabel: UILabel!
    // 飲料詳細介紹 Label
    @IBOutlet weak var detailDrinkDetailLabel: UILabel!
    // 大杯中杯 segmentedControl
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    // 甜度選擇 pickerView
    @IBOutlet weak var sweetPickerView: UIPickerView!
    // 冰塊選擇 pickerView
    @IBOutlet weak var icePickerView: UIPickerView!
    // 加入購物車按鈕
    @IBOutlet weak var cartAddingButton: UIButton!
    // 看購物車明細按鈕
    @IBOutlet weak var cartButton: UIButton!
    // 加配料 Label
    @IBOutlet weak var toppingLabel: UILabel!
    
    // 宣告一個可選型別的 Drink 變數，用來儲存選擇的飲料資訊，如果沒有選擇則為 nil
    var drink: Drink?
    

    // 宣告一個可選型別的 String 變數，用來儲存選擇的飲料價格，如果沒有選擇則為 nil
    var drinkPrice: String?

    // 宣告一個可選型別的 Topping 變數，用來儲存選擇的飲料加料資訊，如果沒有加料則為 nil
    var toppings: Topping?

    // 宣告一個預設值為 "無" 的 String 變數，用來儲存用戶選擇的加料
    var selectedTopping = "無"

    // 宣告一個 Topping 陣列，用來儲存所有可選擇的加料
    var toppingsArray = [Topping]()

    // 宣告一個可選型別的 String 變數，用來儲存選擇的加料價格，如果沒有選擇則為 nil
    var selectedToppingPrice: String?

    // 宣告一個 String 陣列，用來儲存所有可選擇的甜度選項
    let sweet = [
        "正常糖", "少糖", "半糖", "微糖", "二分糖", "一分糖", "無糖"
    ]

    // 宣告一個 String 陣列，用來儲存所有可選擇的冰塊量選項
    let ice = [
        "正常冰", "少冰", "微冰", "去冰", "完全去冰", "常溫", "溫", "熱"
    ]
    
    // 當視圖控制器的視圖載入完成時執行的方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設定大圖片視圖的圖片，如果 drink 中有圖片網址則使用，否則使用預設圖片
        bigImageView.kf.setImage(with: drink?.picUrl, placeholder: UIImage(systemName: "photo"))

        // 設定顯示飲料名稱的標籤文字為選擇的飲料名稱
        detailDrinkNameLabel.text = drink?.name

        // 設定顯示飲料詳細資訊的標籤文字為選擇的飲料描述
        detailDrinkDetailLabel.text = drink?.info.description

        // 將選擇的飲料的大杯價格設定給 drinkPrice 變數
        drinkPrice = drink?.info.L

        // 設定飲料大小選項的預設選擇為第二個選項（大杯）
        sizeSegmentedControl.selectedSegmentIndex = 1
       
        // 更新加入購物車按鈕的標題，顯示目前選擇的飲料價格
        cartAddingButton.setTitle("加入購物車 \(self.drinkPrice!)", for: .normal)

        // 設定購物車按鈕顯示目前購物車中的飲料數量
        self.cartButton.setTitle("\(drinkCount)", for: .normal)

        // 呼叫 fetchToppings 方法來加載可選擇的加料資訊
        fetchToppings(genre: selectedTopping)
     
        // 設定目前選擇的加料標籤為 "無"
        toppingLabel.text = "無"
    }

    // 當使用者變更飲料大小選項時執行的方法
    @IBAction func chooseSize(_ sender: Any) {
        // 檢查目前選擇的是哪個飲料大小選項
        if sizeSegmentedControl.selectedSegmentIndex == 1 {
            // 如果選擇的是大杯，更新飲料價格為大杯價格
            drinkPrice = drink?.info.L
        } else if sizeSegmentedControl.selectedSegmentIndex == 0 {
            // 如果選擇的是中杯，更新飲料價格為中杯價格
            drinkPrice = drink?.info.M
        }
        // 更新加入購物車按鈕的標題以顯示新的價格
        cartAddingButton.setTitle("加入購物車 \(self.drinkPrice!)", for: .normal)
    }

    // 定義一個函數來從遠端 URL 獲取加料資料
    func fetchToppings(genre: String) {
        // 設定加料資料的 URL 字串
        let urlStr = "https://raw.githubusercontent.com/lebonthe/JSON_API/main/kebukeMenu.json"
        // 將字串轉換成 URL
        if let url = URL(string: urlStr) {
            // 使用 URLSession 來發起資料任務
            URLSession.shared.dataTask(with: url) { data, response, error in
                // 檢查是否成功獲取資料
                if let data = data {
                    // 創建一個 JSONDecoder 來解析資料
                    let decoder = JSONDecoder()
                    do {
                        // 嘗試解析資料成 Category 類型的陣列
                        let categories = try decoder.decode([Category].self, from: data)
                        // 找出加料的類別
                        if let toppingCategory = categories.first(where: { $0.category == "加料" }) {
                            // 切換到主線程來更新 UI
                            DispatchQueue.main.async {
                                // 將獲得的加料資料指派給 toppingsArray
                                self.toppingsArray = toppingCategory.toppings ?? []
                                print("Toppings in DetailViewController: \(self.toppingsArray)")
                            }
                        }
                    } catch {
                        // 處理解析錯誤
                        DispatchQueue.main.async {
                            print("解析錯誤: \(error)")
                        }
                    }
                } else if let error = error {
                    // 處理獲取資料時的錯誤
                    DispatchQueue.main.async {
                        print("加載錯誤: \(error)")
                    }
                }
            }.resume()
        }
    }

    // 定義一個方法來處理「加入購物車」按鈕的點擊事件
    @IBAction func addToCart(_ sender: Any) {
        // 確保已經有選擇的飲料信息
        guard let selectedDrink = drink else { return }
        // 獲取用戶在 UIPickerView 上選擇的甜度和冰量
        let selectedSweet = sweet[sweetPickerView.selectedRow(inComponent: 0)]
        let selectedIce = ice[icePickerView.selectedRow(inComponent: 0)]

        // 獲取目前選擇的加料
        guard let selectedTopping = toppingLabel.text else { return }
        // 根據 sizeSegmentedControl 的選擇來決定尺寸和價格
        let selectedSize = sizeSegmentedControl.selectedSegmentIndex == 0 ? "中杯" : "大杯"
        // 根據選擇的尺寸來確定價格
        var selectedPrice = sizeSegmentedControl.selectedSegmentIndex == 0 ?
            Int(selectedDrink.info.M.replacingOccurrences(of: "$", with: "")) ?? 0 :
            Int(selectedDrink.info.L.replacingOccurrences(of: "$", with: "")) ?? 1

        // 如果選擇了加料，則在價格上加 10 元
        if selectedTopping != "無"{
            selectedPrice += 10
        }

        // 檢查是否選擇了熱飲與特定加料的不相容組合
        if (selectedIce == "溫" || selectedIce == "熱") && selectedTopping == "加菓玉" {
            // 顯示一個警告提示用戶更改選擇
            let controller = UIAlertController(title: "菓玉無法於溫熱飲中製作", message: "請重選溫度或配料", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default)
            present(controller, animated: true)
            controller.addAction(okAction)
        } else {
            // 創建一個新的 CartList 物件來表示加入購物車的項目
            let cartItem = CartList(userName: userName,
                                    name: selectedDrink.name,
                                    picUrl: selectedDrink.picUrl,
                                    size: selectedSize,
                                    price: "$\(selectedPrice)",
                                    totalPrice: "$\(selectedPrice)",
                                    sweet: selectedSweet,
                                    ice: selectedIce,
                                    topping: selectedTopping,
                                    count: 1)
            // 將此項目加入到購物車列表中
            cartList.append(cartItem)
            // 更新購物車中的飲料數量
            drinkCount += 1
            // 更新購物車按鈕上顯示的飲料數量
            cartButton.setTitle("\(drinkCount)", for: .normal)
        }
    }

    // 當進行轉場到 CartViewController 時執行的方法
    @IBSegueAction func showCart(_ coder: NSCoder) -> CartViewController? {
        // 根據指定的 coder 創建一個 CartViewController
        let controller = CartViewController(coder: coder)
        return controller
    }

    // 定義一個方法來處理 segue 轉場到 ToppingTableViewController
    @IBSegueAction func showToppingList(_ coder: NSCoder) -> ToppingTableViewController? {
        // 使用指定的 coder 創建 ToppingTableViewController
        let controller = ToppingTableViewController(coder: coder)
        // 將當前選擇的 topping 資訊傳遞給新的控制器
        controller?.selectedTopping = toppingLabel.text
        return controller
    }

    // 定義一個方法來處理從其他視圖控制器返回至此視圖控制器的 Unwind Segue
    @IBAction func unwindToDetailViewController(_ unwindSegue: UIStoryboardSegue) {
        // 檢查從哪個視圖控制器返回
        if let sourceViewController = unwindSegue.source as? ToppingTableViewController {
            // 檢查是否有選擇 topping
            if let toppingName = sourceViewController.selectedTopping,
               let toppingInfo = toppingsArray.first(where: { $0.name == toppingName }) {
                // 更新 topping 標籤和價格
                toppingLabel.text = toppingName
                updatePriceWithTopping(toppingInfo)
            } else {
                print("未找到匹配的 topping 信息")
            }
        }
        // 更新購物車按鈕上的數量
        self.cartButton.setTitle("\(drinkCount)", for: .normal)
    }

    // 定義一個方法來更新飲料價格，考慮所選的 topping
    func updatePriceWithTopping(_ topping: Topping) {
        // 確定基本價格，根據選擇的尺寸（中杯或大杯）
        let basePrice = sizeSegmentedControl.selectedSegmentIndex == 0 ? (drink?.info.M ?? "0") : (drink?.info.L ?? "0")
        let basePriceInt = Int(basePrice.replacingOccurrences(of: "$", with: "")) ?? 0
        // 計算所選 topping 的附加價格
        let additionalPrice = Int(topping.price.replacingOccurrences(of: "$", with: "")) ?? 0
        // 總價格為基本價格加上 topping 的附加價格
        let newTotalPrice = basePriceInt + additionalPrice
        // 更新顯示的價格信息
        drinkPrice = "\(newTotalPrice)"
        cartAddingButton.setTitle("加入購物車 \(newTotalPrice)", for: .normal)
    }

    // 當視圖即將出現時執行的方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 更新購物車中的飲料總數
        updateDrinkCount()
        // 更新購物車按鈕上顯示的飲料數量
        cartButton.setTitle("\(drinkCount)", for: .normal)
    }

    // 定義一個方法來更新購物車中飲料的總數
    func updateDrinkCount() {
        // 使用 reduce 方法來計算購物車中所有項目的總數量
        drinkCount = cartList.reduce(0) { $0 + $1.count }
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

// 擴展 DetailViewController 以實現 UIPickerViewDelegate 和 UIPickerViewDataSource
extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 返回 UIPickerView 中的組件數量，這裡是 1 因為只有一列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // 根據選擇的 pickerView（甜度或冰量）返回對應的行數
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sweetPickerView {
            // 如果是甜度選擇器，返回甜度選項的數量
            return sweet.count
        } else if pickerView == icePickerView {
            // 如果是冰量選擇器，且如果該飲料不提供熱飲選項，則減去最後三個熱飲選項
            if drink?.info.hotAvailable == false {
                return ice.count - 3
            } else {
                // 否則返回完整的冰量選項數量
                return ice.count
            }
        }
        // 若非上述兩種情況，返回 0
        return 0
    }

    // 設定 UIPickerView 的每行顯示的標題
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sweetPickerView {
            // 如果是甜度選擇器，返回對應行的甜度選項
            return sweet[row]
        } else if pickerView == icePickerView {
            // 如果是冰量選擇器，返回對應行的冰量選項
            return ice[row]
        }
        // 若非上述兩種情況，返回 nil
        return nil
    }
}

