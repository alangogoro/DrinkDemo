//
//  NetworkController.swift
//  DrinkDemo
//
//  Created by usr on 2020/9/3.
//

import Foundation

struct NetworkController {
    static let shared = NetworkController()
    static let API_str = "https://sheetdb.io/api/v1/sxshuy0z1ixnn"
    
    var requestUrl = URLRequest(url: URL(string: API_str)!)
    
    func submitOrder(with order: OrderData,
                     completionHandler: @escaping(Bool?) -> Void) {
        
        var request = requestUrl
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(order) {
            
            let task = URLSession.shared.uploadTask(with: request, from: data) { (retData, res, err) in
                if let retData = retData {
                    
                    do {
                        let decoder = JSONDecoder()
                        let dic = try decoder.decode([String: Int].self, from: retData)
                        if dic["created"] == 1 {
                            print("建立訂單成功1筆")
                            completionHandler(true)
                        } else {
                            print("訂單建立失敗")
                            completionHandler(false)
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }
            task.resume()
            
        }
        
    }
    
}
