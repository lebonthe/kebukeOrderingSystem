//
//  EnteringViewController.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/23.
//

import UIKit

class EnteringViewController: UIViewController {
    // 歡迎文字
    @IBOutlet weak var welcomeLabel: UILabel!
    // 問題
    @IBOutlet weak var questionLabel: UILabel!
    // 名字輸入 textField
    @IBOutlet weak var nameTextField: UITextField!
    // 點餐 button
    @IBOutlet weak var startButton: UIButton!
    // 設定計時器
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 這裡初始化那些只需要設置一次的元素
        startButton.isHidden = true
        questionLabel.isHidden = true
        nameTextField.isHidden = true
    }
    @IBAction func unwindToEnteringvViewController (_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    // view 即將出現時
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 若 questionLabel 與 nameTextField 還沒出現
        if questionLabel.isHidden && nameTextField.isHidden {
            showTextWithAnimation() // 執行動畫
        }
    }
    func showTextWithAnimation() {
        // 建立過渡效果
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromBottom

        // 啟動動畫，顯示元素
        questionLabel.isHidden = false
        nameTextField.isHidden = false
        questionLabel.layer.add(transition, forKey: "showText")
        nameTextField.layer.add(transition, forKey: "showText")

        // 重新設置計時器
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
            // 這裡可以放置計時器到時後的操作
        })
    }
    // 輸入姓名（Editing Changed）
    @IBAction func typeName(_ sender: UITextField) {
        // 只要 nameTextField 不是空白的，點餐 button 就出現
        if nameTextField.text != ""{
            startButton.isHidden = false
        }else{
            startButton.isHidden = true
        }
    }

    // 點畫面收鍵盤
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // 當 view 消失時，計時器停止
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // 此函式會在轉場到 OrderViewController 時被調用。
    @IBSegueAction func sendNameToOrderPage(_ coder: NSCoder) -> OrderViewController? {

        // 創建 OrderViewController 的一個實例。使用 coder 參數，這是用於在 storyboard 轉場中初始化視圖控制器所需的。
        let controller = OrderViewController(coder: coder)

        // 檢查 nameTextField 是否有文本
        if nameTextField.text != nil {
        //     如果有，將該文本設置為 OrderViewController 的 userName 屬性
        //     在轉場到下一個畫面時，將用戶輸入的名字傳遞過去。
            userName = nameTextField.text!
        }
        // 返回創建的 OrderViewController 實例，進行轉場。
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
