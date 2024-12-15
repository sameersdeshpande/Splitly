//
//  Category.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 11/30/24.
//

import Foundation
struct Category {
    var categoryId: Int64
    var categoryName: String
    init(categoryId: Int64, categoryName: String) {
            self.categoryId = categoryId
            self.categoryName = categoryName
        }
}
