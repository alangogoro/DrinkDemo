//
//  OrderTableViewController.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/4.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var orders: [Order] = [Order]()
    
    var activityIndicator = UIActivityIndicatorView()
    var isLoading: Bool   = true
        
    private let reuseIdentifier  = "orderCell"
    private let footerIdentifier = "footerCell"
    private let heightForFooter:  CGFloat = 50.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRefreshControl()
    }
    
    /* 在 viewDidLayoutSubviews() 中，元件的位置大小才是確定 */
    override func viewDidLayoutSubviews() {
        activityIndicator = Common.shared.setIndicator(in: self, with: activityIndicator)
        //print("view.frame = \(view.frame.size)")
        //print("view.safeAreaLayoutGuide = \(view.safeAreaLayoutGuide.layoutFrame.size)") // SafeArea 比較矮
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /* 呈現載入指標後再抓資料 */
        Common.shared.displayActivityIndicator(activityIndicator, isActive: isLoading)
        
        fetchOrders()
    }
    
    @objc func fetchOrders() {
        NetworkController.shared.fetchOrders { [self] orders in
            guard orders != nil else {
                print("未取得訂單列表")
                return
            }
            self.orders = orders!
            
            DispatchQueue.main.async {
                tableView.reloadData()
                /* 停止載入指標 */
                isLoading = false
                Common.shared.displayActivityIndicator(activityIndicator, isActive: isLoading)
                /* 停止下拉更新 */
                refreshControl?.endRefreshing()
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orders.count == 0 {
            return 1
        }
        return orders.count
    }
    /* ========== TableView 的 footer ========== */
    override func tableView(_ tableView: UITableView,
                            viewForFooterInSection section: Int) -> UIView? {
        
        if orders.count == 0 { // 不確定這一段有作用
            return nil
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: footerIdentifier) as? FooterTableViewCell
        else { return nil }
        
        let count = orders.count
        let total = DrinkHelper.shared.sumToal(orders: orders)
        cell.setup(count: count, amount: total)
        return cell.contentView
    }
    override func tableView(_ tableView: UITableView,
                            heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? OrderTableViewCell
        else { return UITableViewCell() }
        
        /* 若沒有任何訂單資料 */
        if orders.count == 0 {
            
            cell.drinkImageView.image = UIImage(systemName: "book")
            cell.nameLabel.text = "無訂單紀錄"
            // 設定 Label 文字置中
            cell.nameLabel.textAlignment = .center
            // 修改 cell 樣式 & 不可選取
            cell.drinkLabel.text = ""
            cell.accessoryType  = .none
            cell.selectionStyle = .none
            
        } else {
            let order = orders[indexPath.row]
            cell.setup(with: order)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(identifier: PropertyKeys.orderController) as? OrderViewController {
            
            /* 呈現 ViewController：present ↔️ dismiss
             * 此處測試可以成功換頁，於5秒後退回首頁 */
            present(controller, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    controller.dismiss(animated: true)
                }
            }
        }
    }
    
    /**
     設定 TableView 的下拉更新
     */
    func setRefreshControl() {
        
        refreshControl = UIRefreshControl()
        // 設定更新文字的顏色
        let attributes =
            [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        // 設定更新文字的內容
        refreshControl?.attributedTitle =
            NSAttributedString(string: "正在更新", attributes: attributes)
        // 設定更新元件的顏色
        refreshControl?.tintColor = UIColor.systemRed
        // 設定背景顏色
        refreshControl?.backgroundColor = UIColor.clear
        // 設定 TableView 的下拉更新屬性
        tableView.refreshControl = refreshControl
        // 設定下拉更新事件
        refreshControl?.addTarget(self,
                                  action: #selector(fetchOrders),
                                  for: UIControl.Event.valueChanged)
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
