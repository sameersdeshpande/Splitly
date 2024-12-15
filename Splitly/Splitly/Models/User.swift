//
//  User.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 11/27/24.
//

// Models/User.swift
// Models/User.swift
import Foundation

struct User {
    var userId: Int64      // User ID (Int)
    var username: String // Username
    var email: String    // Email address
    var password: String // Password (for local authentication)
    var displayPhoto: String?  // URL or file path for the display photo
    
    // Initializer
    init(userId: Int64, username: String, email: String, password: String, displayPhoto: String? = nil) {
        self.userId = userId
        self.username = username
        self.email = email
        self.password = password
        self.displayPhoto = displayPhoto
    }
}


