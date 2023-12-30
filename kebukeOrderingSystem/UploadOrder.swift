//
//  UploadOrder.swift
//  kebukeOrderingSystem
//
//  Created by Min Hu on 2023/12/28.
//

import Foundation

struct UploadOrder: Codable {
    let records: [Record]
}

struct Record: Codable {
    let fields: UploadDrink
}

struct UploadDrink: Codable {
    let userName: String
    let name: String
    let size: String
    let sweet: String
    let ice: String
    let topping: String
    let count: Int
    let price: String
    let totalPrice: String
}
