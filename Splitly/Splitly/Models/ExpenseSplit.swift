//
//  ExpenseSplit.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 12/1/24.
//

import Foundation
struct ExpenseSplit {
    var splitId: Int64 // The split ID (auto-incremented)
    var expenseId: Int64 // The associated expense ID
    var userId: Int64 // The user ID
    var amount: Double // The split amount
}

