//
//  Order.swift
//  JustDrink
//
//  Created by usr on 2020/8/27.
//

import Foundation

struct Order: Codable {
    
    var name:    String
    var drinkId: String
    var drink:   String
    var size:    String
    var sweetnessLevel: String
    var iceAmount: String
    var price:     String
    var date:      String?
    
}

struct OrderData: Codable {
    var data: Order
}
