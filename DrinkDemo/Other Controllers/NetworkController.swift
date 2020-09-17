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
            
            let task = URLSession.shared.uploadTask(with: request, from: data) { (returnData, res, err) in

                if let returnData = returnData {
                    do {
                        let decoder = JSONDecoder()
                        let dic = try decoder.decode([String: Int].self, from: returnData)
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
    
    func fetchOrders(completionHandler: @escaping([Order]?) -> Void) {
        
        var request = requestUrl
        request.httpMethod = "GET"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error = \(error!.localizedDescription)")
            }
            //回傳的data為自訂型別的陣列，用JSONDecoder解碼
            let decoder = JSONDecoder()
            if let data = data, let orders = try? decoder.decode([Order].self, from: data) {
                //print(String(data: data, encoding: .utf8)!)
                completionHandler(orders)
            } else {
                completionHandler(nil)
            }
        }.resume()
    }
    
    func updateOrder(at order: Order,
                     completionHandler: @escaping(Bool?) -> Void) {
        
        let url_str = Self.API_str
        let updateUrl_str = "\(url_str)/name/\(order.name)"
        
        if let urlStr = updateUrl_str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStr) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(OrderData(data: order)) {
                let task = URLSession.shared.uploadTask(with: request, from: data) { (returnData, response, error) in
                    
                    if error != nil {
                        print("Error = \(error!.localizedDescription)")
                    }
                    let decoder = JSONDecoder()
                    if let returnData = returnData,
                       let dic = try? decoder.decode([String: Int].self, from: returnData) {
                        print(dic)
                        if dic["updated"] != nil {
                            print("Update Successfully")
                            completionHandler(true)
                        } else {
                            print("Update Failed")
                            completionHandler(false)
                        }
                    }
                    
                }
                task.resume()
            }
            
        }
        
    }
    
    func deleteOrder(at order: Order,
                     completionHanlder: @escaping (Bool?) -> Void) {
        
        let url_str = Self.API_str
        let deleteUrl_str = "\(url_str)/name/\(order.name)"
        
        if let urlStr = deleteUrl_str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStr) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error = \(error!.localizedDescription)")
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let dic = try decoder.decode([String: Int].self, from: data)
                        if dic["deleted"] != nil {
                            print("刪除訂單成功")
                            completionHanlder(true)
                        } else {
                            print("刪除訂單失敗")
                            completionHanlder(false)
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
