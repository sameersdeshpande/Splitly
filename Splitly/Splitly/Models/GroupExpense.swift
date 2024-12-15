//
//  GroupExpense.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 12/10/24.
//

import Foundation


// Define the GroupExpense model
struct GroupExpense: Identifiable {
    var id: Int64
    var description: String
    var amount: Double
    var groupId: Int64
    var payerId: Int64
    var participants: [String] // Or, you can have this as an array of User objects if you want
    var splitAmounts: [Int64: Double] // A dictionary with userId -> split amount
}
