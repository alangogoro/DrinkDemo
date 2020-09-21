//
//  OrderUpdateViewController.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/17.
//

import UIKit

class OrderUpdateViewController: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sizeSementedControl: UISegmentedControl!
    @IBOutlet weak var drinkTextField: UITextField!
    @IBOutlet weak var sugarSementedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    
    var order: Order!
    var drinks: [Drink] = [Drink]()
    var drink: Drink?
    var pickerTextField: UITextField!
    var pickerSelectedRow: Int!
    
    /* ========== ActivityIndicator ========== */
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        drinkTextField.delegate = self
        
        DrinkHelper.shared.fetchDrinkList { [self] drinks in
            guard drinks != nil else {
                print("未取得飲料列表")
                return
            }
            self.drinks = drinks!
            /* 由訂單的飲料ID去取得該飲料的資訊
             * 本頁主要用於初始化 PickerView 的 row */
            for i in 0..<self.drinks.count {
                if self.drinks[i].id == order.drinkId {
                    self.drink = self.drinks[i]
                    break
                }
            }
        }
        
        setViews()
    }
    
    func setViews() {
        nameTextField.text = order.name
        drinkTextField.text = order.drink
        sizeSementedControl.selectedSegmentIndex = getSizeIndex(from: order)
        sugarSementedControl.selectedSegmentIndex = getSugarIndex(from: order)
        iceSegmentedControl.selectedSegmentIndex = getIceIndex(from: order)
    }
    
    override func viewDidLayoutSubviews() {
        activityIndicator = Common.shared
            .setIndicator(in: self, with: activityIndicator)
    }
    
    @IBAction func submitUpdate(_ sender: Any) {
        
        guard nameTextField.text != "" else {
            Common.shared.showAlert(in: self, with: "請輸入名字")
            return
        }
        guard drinkTextField.text != "" else {
            Common.shared.showAlert(in: self, with: "請選擇飲料")
            return
        }
        
        Common.shared
            .displayActivityIndicator(activityIndicator, isActive: true)
        
        let name = nameTextField.text!
        let drinkId = drink!.id
        let drinkName = drinkTextField.text!
        let size = Size.allCases[sizeSementedControl.selectedSegmentIndex].rawValue
        let sweetnessLevel = sugarSementedControl.titleForSegment(at: sugarSementedControl.selectedSegmentIndex)!
        let iceAmount = iceSegmentedControl.titleForSegment(at: iceSegmentedControl.selectedSegmentIndex)!
        let price = drink!.options[sizeSementedControl.selectedSegmentIndex].price
        let date = Common.shared.dateString()
        
        let order = Order(name: name,
                          drinkId: drinkId,
                          drink: drinkName,
                          size: size,
                          sweetnessLevel: sweetnessLevel,
                          iceAmount: iceAmount,
                          // 因為使用 JSON 解碼時只能得出字串，所以在這裡也把 Int 轉為 String
                          price: String(price),
                          date: date)
        
        NetworkController.shared.updateOrder(at: order) { [self] result in
            if result == true {
                DispatchQueue.main.async {
                    Common.shared.displayActivityIndicator(activityIndicator, isActive: false)
                    Common.shared.showAlertNavToRoot(in: self, with: "訂單更新成功")
                }
            } else {
                DispatchQueue.main.async {
                    Common.shared.displayActivityIndicator(activityIndicator, isActive: false)
                    Common.shared.showAlert(in: self, with: "訂單更新失敗")
                }
            }
        }
    }
        
        func getSizeIndex(from order: Order) -> Int {
            var index = 0
            let sizes = Size.allCases
            for i in 0..<sizes.count {
                if sizes[i].rawValue == order.size {
                    index = i
                    break
                }
            }
            return index
        }
        func getSugarIndex(from order: Order) -> Int {
            var index = 0
            let sweetLevels = SweetnessLevel.allCases
            for i in 0..<sweetLevels.count {
                if sweetLevels[i].rawValue == order.sweetnessLevel {
                    index = i
                    break
                }
            }
            return index
        }
        func getIceIndex(from order: Order) -> Int {
            var index = 0
            let iceAmounts = IceAmount.allCases
            for i in 0..<iceAmounts.count {
                if iceAmounts[i].rawValue == order.iceAmount {
                    index = i
                    break
                }
            }
            return index
        }
        
        /* ========== initPickerView ========== */
        func initPickerView() {
            let pickerView = UIPickerView()
            pickerView.delegate   = self
            pickerView.dataSource = self
            let drinkRow = (Int(drink?.id ?? "1")! - 1) //轉換從 1 開始的 String 變成 row
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
                    self.drinkTextField.text = self.drinks[selectedRow].name
                }
                pickerTextField.resignFirstResponder()
            } else {
                pickerTextField.resignFirstResponder()
            }
        }
        @objc func cancelSelect() {
            pickerTextField.resignFirstResponder()
        }
        
    }


extension OrderUpdateViewController: UITextFieldDelegate {
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
extension OrderUpdateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinks[row].name
    }
    /* ========== 指派被選取的飲料整數 ========== */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelectedRow = row
    }
}
