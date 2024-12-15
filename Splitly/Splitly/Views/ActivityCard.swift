//
//  ActivityCard.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 12/12/24.
//

import Foundation
import SwiftUI

struct ActivityCard: View {
    var expense: Expense
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.green)
                    .padding(10)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(expense.description)
                        .font(.body)
                    Text("Category: \(getCategoryName(for: expense.categoryId))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Amount: ₹\(expense.amount, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Divider()
        }
    }
    
    private func getCategoryName(for categoryId: Int64) -> String {
        var databaseManager = DatabaseManager.shared
        if let category = databaseManager.fetchCategoryById(categoryId: categoryId) {
            return category.categoryName
        }
        return "Unknown"
    }
}
