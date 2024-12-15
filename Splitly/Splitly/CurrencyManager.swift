////
////  CurrencyManager.swift
////  Splitly
////
////  Created by Sameer Shashikant Deshpande on 12/12/24.
////
//
//import Foundation
//import SwiftUI
//
//
//
//class CurrencyManager {
//    static let shared = CurrencyManager()
//    
//    // Store the selected currency code (default "INR")
//    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
//    
//    // Currency symbols mapping
//    private let currencySymbols = [
//        "INR": "₹",
//        "USD": "$",
//        "EUR": "€",
//        "GBP": "£"
//    ]
//    
//    // Function to get the symbol for the selected currency
//    func selectedCurrencySymbol() -> String {
//        return currencySymbols[selectedCurrency] ?? ""
//    }
//    
//    // Function to update the selected currency
//    func setSelectedCurrency(_ currency: String) {
//        selectedCurrency = currency
//    }
//}
//
//  CurrencyManager.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 12/12/24.
//

import Foundation
import SwiftUI

class CurrencyManager {
    static let shared = CurrencyManager()
    
    // Store the selected currency code (default "INR")
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    
    // Currency symbols mapping
    private let currencySymbols = [
        "INR": "₹",
        "USD": "$",
        "EUR": "€",
        "GBP": "£"
    ]
    
    // Exchange rates (INR is considered the base currency)
    private let exchangeRates: [String: Double] = [
        "INR": 1.0,     // 1 INR = 1 INR
        "USD": 0.012,   // 1 INR = 0.012 USD
        "EUR": 0.011,   // 1 INR = 0.011 EUR
        "GBP": 0.009    // 1 INR = 0.009 GBP
    ]
    
    // Function to get the symbol for the selected currency
    func selectedCurrencySymbol() -> String {
        return currencySymbols[selectedCurrency] ?? "₹"  // Default to INR symbol if not found
    }
    
    // Function to convert amount from INR to selected currency
    func convertAmount(_ amount: Double) -> Double {
        guard let rate = exchangeRates[selectedCurrency] else {
            return amount  // If no rate found, return the original amount
        }
        return amount * rate  // Convert based on the selected currency's rate
    }
    
    // Function to update the selected currency
    func setSelectedCurrency(_ currency: String) {
        selectedCurrency = currency
    }
}
