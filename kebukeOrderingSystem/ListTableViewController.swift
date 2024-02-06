//
//  ListTableViewController.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/28.
//

import UIKit

// 用來顯示從伺服器下載的訂單列表的視圖控制器
class ListTableViewController: UITableViewController {
    // 儲存從伺服器下載的飲料訂單數據
    var downloadList = [UploadDrink]()
    
    // 連接到 storyboard 中的活動指示器
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // 當視圖加載完成時被呼叫
    override func viewDidLoad() {
        super.viewDidLoad()
        // 啟動活動指示器並顯示
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        // 從伺服器獲取訂單數據
        fetchItems()
    }

    // 從伺服器獲取訂單數據的方法
    func fetchItems() {
        // 設定請求的 URL
        let url = URL(string: "https://api.airtable.com/v0/appydWW9bHuuV62CI/drinks")!
        var request = URLRequest(url: url)
        // 設定授權權杖
        request.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
        // 設定 HTTP 方法為 GET
        request.httpMethod = "GET"
        // 發送網路請求
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    // 解碼數據為 UploadOrder 結構
                    let uploadOrder = try decoder.decode(UploadOrder.self, from: data)
                    // 提取並更新 downloadList
                    DispatchQueue.main.async {
                        self.downloadList = uploadOrder.records.map { $0.fields }
                        // 重新加載表格視圖
                        self.tableView.reloadData()
                        // 停止並隱藏活動指示器
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("解碼錯誤: \(error)")
                        // 停止並隱藏活動指示器
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("加載錯誤: \(error)")
                    // 停止並隱藏活動指示器
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                }
            }
        }.resume()
    }

    // 當視圖即將出現時被呼叫
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次視圖即將顯示時，重新從伺服器獲取數據
        fetchItems()
    }

    // MARK: - Table view data source

    // 回傳表格視圖的分區數
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 回傳每個分區的列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadList.count
    }

    // 設定每列的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 從重用池獲得一個 ListTableViewCell 實例
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as? ListTableViewCell
        // 獲取對應的訂單數據
        let item = downloadList[indexPath.row]
        
        // 將數據設定到表格視圖列中
        cell?.userNameLable.text = item.userName
        cell?.drinkNameLabel.text = item.name
        cell?.iceLabel.text = item.ice
        cell?.sweetLabel.text = item.sweet
        cell?.toppingLabel.text = item.topping
        cell?.countLabel.text = String(item.count)
        cell?.priceLabel.text = item.price
        cell?.sizeLabel.text = item.size
        cell?.totalPriceLabel.text = item.totalPrice
         

        return cell ?? UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
