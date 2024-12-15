//
//  Expense.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 11/28/24.
//


import Foundation

struct Expense:Identifiable {
    var id: Int64
    var amount: Double
    var description: String
    var categoryId: Int64
    var payerId: Int64
    var customSplitAmounts: [Int64: Double] 
    
    init(id: Int64 = 0, amount: Double, description: String, categoryId: Int64, payerId: Int64, customSplitAmounts: [Int64: Double] = [:]) {
        self.id = id
        self.amount = amount
        self.description = description
        self.categoryId = categoryId
        self.payerId = payerId
        self.customSplitAmounts = customSplitAmounts
    }
}
