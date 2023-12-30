//
//  KebukeMenu.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/22.
//

import Foundation

//class GlobalData {
//    static let shared = GlobalData()
//    var drinkCount: Int = 0
//    var cartList: [CartList] = []
//
//    private init() {}
//}



var userName = ""
var drinkCount:Int = 0
var cartList = [CartList]()

enum ChosenCategory:Int{
    case 季節限定,單品茶,調茶,雲蓋,歐蕾
}

struct CartList: Codable{
    var userName: String
    var name:String
    var picUrl: URL
    var size: String
    var price: String
    var totalPrice: String
    var sweet: String
    var ice: String
    var topping: String
    var count: Int
}

struct Category: Decodable {
    let category: String
    let drinks: [Drink]? // option，因為不是每個類別都有 drinks
    let toppings: [Topping]?
}

struct Drink: Decodable {
    let name: String
    let info: Info
    let picUrl: URL
}

struct Info: Decodable {
    let M: String
    let L: String
    let description: String
    let hotAvailable: Bool
}

struct Topping: Decodable {
    let name: String
    let price: String
}
