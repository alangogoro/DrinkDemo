//
//  DrinkData.swift
//  JustDrink
//
//  Created by usr on 2020/8/20.
//

import Foundation

struct Drink: Codable {
    var id:  String
    var name: String
    var category: DrinkCategory // Category 型別已經被用走
    var options: [Option]
}

struct Option: Codable {
    var size: String
    var price: Int
}

enum DrinkCategory: String, Codable {
    case 原茶類, 奶茶類, 鮮奶類, 水果類
}
enum SweetnessLevel: String, CaseIterable {
    case regular = "正常"
    case less    = "少糖"
    case half    = "半糖"
    case quarter = "微糖"
    case free    = "無糖"
}
enum IceAmount: String, CaseIterable {
    case regular = "正常"
    case easy    = "少冰"
    case free    = "去冰"
    case hot     = "熱飲"
}
