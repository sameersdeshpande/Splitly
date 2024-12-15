//
//  Transaction.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 11/28/24.
//

//import Foundation
//import SwiftUI
//
//// Define a custom struct for a transaction.
//struct Transaction: Identifiable {
//    var id: Int // Changed to an integer ID instead of String
//    var payer: String // Name of the person who paid
//    var amount: Double // The total amount paid
//    var category: String // Category of the expense (e.g., "Dinner", "Uber", etc.)
//    var date: Date // Date of the transaction
//    var participants: [String] // List of participants involved in the transaction
//    
//    // Computed property to format the date in a readable format
//    var formattedDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
//        return dateFormatter.string(from: date)
//    }
//    
//    // Computed property to calculate individual share if the transaction is split equally
//    var individualShare: Double {
//        return amount / Double(participants.count)
//    }
//}
