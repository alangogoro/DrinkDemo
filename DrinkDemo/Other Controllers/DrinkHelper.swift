//
//  MenuController.swift
//  JustDrink
//
//  Created by usr on 2020/8/28.
//

import Foundation

struct DrinkHelper {
    static let shared = DrinkHelper()
    
    func fetchDrinkList(completion: @escaping ([Drink]?) -> ()) {
        
        // 取得 plist 檔的 URL
        let url = Bundle.main.url(forResource: "Drinks", withExtension: "plist")!
        
        /* 從 url 讀取 data 後
         * 利用 PropertyListDecoder 將 data 變成型別 [Drink] 的 array */
        if let data = try? Data(contentsOf: url),
           let drinks = try? PropertyListDecoder().decode([Drink].self, from: data) {
            // print(drinks)
            completion(drinks)
        } else {
            completion(nil)
        }
        
    }
    
    func sumToal(orders: [Order]) -> Int {
        var total = 0
        orders.forEach { order in
            total += Int(order.price)!
        }
        return total
    }
}
