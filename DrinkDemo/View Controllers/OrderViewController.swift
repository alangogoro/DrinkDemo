//
//  OrderViewController.swift
//  JustDrink
//
//  Created by usr on 2020/8/27.
//

import UIKit

class OrderViewController: UITableViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var drinkTextField: UITextField!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    
    /* ========== PickerView ========== */
    var pickerTextField: UITextField!
    var pickerSelectedRow: Int!
    var drinkList = [String]() // 飲料名字的陣列
    /* ========== ActivityIndicator ========== */
    var activityIndicator = UIActivityIndicatorView()
    
    var drink: Drink!
    var drinks: [Drink] = [Drink]()
    let sizes = ["M", "L"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* ========== TextField 的 delegate ========== */
        nameTextField.delegate  = self
        drinkTextField.delegate = self
        
        DrinkHelper.shared.fetchDrinkList { drinks in
            guard drinks != nil else {
                return
            }
            self.drinks = drinks!
            drinks!.forEach({ (drink) in
                self.drinkList.append(drink.name)
            })
        }
        setViews()
    }
    
    /* 在 viewDidLayoutSubviews() 中，元件的位置大小才是確定 */
    override func viewDidLayoutSubviews() {
        activityIndicator = Common.shared
            .setIndicator(in: self, with: activityIndicator)
    }
    
    func setViews() {
        drinkTextField.text = drink!.name
        imageView.image = UIImage(named: drink.id)
    }
    
    /* ========== 送出訂單並視結果換頁 ========== */
    @IBAction func submitOrder(_ sender: Any) {
        
        guard nameTextField.text != "" else {
            Common.shared.showAlert(in: self, with: "請輸入名字")
            return
        }
        guard drinkTextField.text != "" else {
            Common.shared.showAlert(in: self, with: "請選擇飲料")
            return
        }
        
        // 顯示載入指標
        Common.shared
            .displayActivityIndicator(activityIndicator, isActive: true)
        
        let name = nameTextField.text!
        let drinkId = drink.id
        let drinkName = drinkTextField.text!
        let size = sizes[sizeSegmentedControl.selectedSegmentIndex]
        /* enum 遵從 CaseIterable protocol
         * 可以使用 .allCases 取得 Array */
        let sweetnessLevel = SweetnessLevel.allCases[sugarSegmentedControl.selectedSegmentIndex].rawValue
        /* 用 UISegmentedControl.titleForSegment 取得區段標題 */
        let iceAmount = iceSegmentedControl.titleForSegment(at: iceSegmentedControl.selectedSegmentIndex)!
        let price = drink.options[sizeSegmentedControl.selectedSegmentIndex].price
        let date = Common.shared.dateString()
        
        let order = Order(name:  name,
                          drinkId: drinkId,
                          drink: drinkName,
                          size:  size,
                          sweetnessLevel: sweetnessLevel,
                          iceAmount: iceAmount,
                          // 因為使用 JSON 解碼時只能得出字串，所以在這裡也把 Int 轉為 String
                          price: String(price),
                          date:  date)
        let orderData = OrderData(data: order)
        NetworkController.shared.submitOrder(with: orderData) { [self] result in
            if result == true {
                DispatchQueue.main.async {
                    // 停止載入指標
                    Common.shared.displayActivityIndicator(activityIndicator, isActive: false)
                    /* 顯示確認視窗 Alert 並且透過
                     * navigationController.popToRootViewController 返回主頁 */
                    Common.shared.showAlertNavToRoot(in: self, with: "訂購成功")
                    /* ❌ 顯示確認視窗並返回上一頁
                     * 但是在生成 Alert 時會因爲發起換頁，所以沒有 ViewController 可以 present */
                    /* self.navigationController?.popViewController(animated: true)
                    Common.shared.showAlert(in: self, with: "訂購成功") */
                }
            } else {
                DispatchQueue.main.async {
                    Common.shared.displayActivityIndicator(activityIndicator, isActive: false)
                    Common.shared.showAlert(in: self, with: "訂購失敗")
                }
            }
        }
    }
    
    /* ========== initPickerView ========== */
    func initPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate   = self
        pickerView.dataSource = self
        let drinkRow = Int(drink.id)! - 1 //轉換從 1 開始的 String 變成 row
        pickerView.selectRow(drinkRow, inComponent: 0, animated: true)
        
        /* ========== PickerView 上方的一條 TooBar 設定 ========== */
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = .systemBlue
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(didSelect))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelSelect))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        /* ========== TextField 設定 ========== */
        pickerTextField = UITextField(frame: CGRect.zero)
        view.addSubview(pickerTextField)
        pickerTextField.inputView = pickerView
        pickerTextField.inputAccessoryView = toolbar
        pickerTextField.becomeFirstResponder()
    }
    
    /* ========== Toolbar Button functions ========== */
    @objc func didSelect() {
        
        if let selectedRow = pickerSelectedRow {
            drink = drinks[selectedRow]
            DispatchQueue.main.async {
                self.drinkTextField.text = self.drinkList[selectedRow]
            }
            pickerTextField.resignFirstResponder()
        } else {
            pickerTextField.resignFirstResponder()
        }
    }
    @objc func cancelSelect() {
        pickerTextField.resignFirstResponder()
    }
    
        
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /* ⭐️ 回傳 UITableView.automaticDimension
         * 可以讓 cell 自動計算高度 ⭐️ */
        
        return UITableView.automaticDimension
    }
    /* ===== 不確定有正確作用 =====
     * ⌨️ 點按空白處，呼叫 view.endEditing() 收起鍵盤 */
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        view.endEditing(true)
    }
}

/* ========== UITextViewDelegate protocols ========== */
extension OrderViewController: UITextFieldDelegate {
    /* 控制使用者點選 TextField 時，會出現鍵盤 ⌨️ 或跳出 PickerView */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.becomeFirstResponder()
        } else {
            DispatchQueue.main.async {
                self.initPickerView()
            }
        }
    }
    /* ⌨️ 控制使用者按下 Return 後，收起鍵盤 */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/* ========== UIPickerView protocols ========== */
extension OrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinkList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinkList[row]
    }
    /* ========== 指派被選取的飲料整數 ========== */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelectedRow = row
    }
}
