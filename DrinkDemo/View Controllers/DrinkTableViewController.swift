//
//  ViewController.swift
//  JustDrink
//
//  Created by usr on 2020/8/20.
//

import UIKit

class DrinkTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellId = "drinkCell"
    
    var drinks = [Drink]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* TableView 的 delegate&dataSource 代理 */
        tableView.delegate   = self
        tableView.dataSource = self
        
        // 測試能否印出每一種飲料
        DrinkHelper.shared.fetchDrinkList { drinks in
            if let drinks = drinks {
                self.drinks = drinks
            } else {
                print("未能取得飲料列表")
            }
            /* $0?.forEach({ (drink) in
                self.drinklist.append(drink)
                //print("\(drink.id)\t\(drink.name) \(drink.options[0].size) \(drink.options[0].price)\t\(drink.options[1].size) \(drink.options[1].price)")
            }) */
        }
        
    }
}


extension DrinkTableViewController: UITableViewDelegate,
                                    UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DrinkTableViewCell
        else { return UITableViewCell() }
        
        let drink = drinks[indexPath.row]
        cell.setup(with: drink)
        
        return cell
    }
    /* 滑動刪除 row */
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        drinks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OrderViewController,
           let row = tableView.indexPathForSelectedRow?.row {
            controller.drink = drinks[row]
        }
    }
}
