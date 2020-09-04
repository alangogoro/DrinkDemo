//
//  OrderTableViewController.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/4.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var isLoading: Bool?
    var activityIndicator = UIActivityIndicatorView()
    
    var orders: [Order] = [Order]()
    
    private let reuseIdentifier = "orderCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /* 在 viewDidLayoutSubviews() 中，元件的位置大小才是確定 */
    override func viewDidLayoutSubviews() {
        activityIndicator = Common.shared.setIndicator(in: self, with: activityIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLoading = true
        Common.shared.displayActivityIndicator(activityIndicator, isActive: isLoading!)
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
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                as? OrderTableViewCell else { return UITableViewCell() }
        if orders.count == 0 { /*
            cell.imageView.image = UIImage(systemName: "cloud")
            cell.groupNameLabel.text = "尚無訂購紀錄"
            cell.accessoryType = .none
            cell.selectionStyle = .none */
        } else {
            /* let order = orders[indexPath.row]
            cell.update(with: order) */
        }
        return cell
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