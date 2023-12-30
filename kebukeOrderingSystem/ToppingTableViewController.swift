//
//  ToppingTableViewController.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/29.
//
import UIKit

class ToppingTableViewController: UITableViewController {
    
    var selectedTopping: String? // 儲存選擇的配料名稱
    var toppingsArray = [Topping]() // 儲存從 JSON 數據解析得到的配料陣列

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems() // 從網路加載配料數據
    }

    func fetchItems() {
        // 設定 JSON 數據的 URL
        let urlStr = "https://raw.githubusercontent.com/lebonthe/JSON_API/main/kebukeMenu.json"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([Category].self, from: data)
                        if let toppingCategory = decodedData.first(where: { $0.category == "加料" }) {
                            self.toppingsArray = toppingCategory.toppings ?? []
                            DispatchQueue.main.async {
                                self.tableView.reloadData() // 加載完數據後刷新表格
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("解析錯誤: \(error)")
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        print("加載錯誤: \(error)")
                    }
                }
            }.resume()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // 表格有一個區段
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppingsArray.count // 表格的行數為配料陣列的數量
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingTableViewCell", for: indexPath) as? ToppingTableViewCell
        let item = toppingsArray[indexPath.row]
        cell?.nameLabel.text = item.name // 顯示配料名稱
        cell?.priceLabel.text = item.price // 顯示配料價格
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTopping = toppingsArray[indexPath.row].name // 當選擇某行時，設定選擇的配料
        performSegue(withIdentifier: "unwindToDetailViewController", sender: self) // 執行 segue 以返回 DetailViewController
    }

//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "unwindToDetailViewController",
//           let destinationVC = segue.destination as? DetailViewController {
//            destinationVC.selectedTopping = self.selectedTopping ?? "" // 將選擇的配料傳遞給 DetailViewController
//        }
//    }
}
