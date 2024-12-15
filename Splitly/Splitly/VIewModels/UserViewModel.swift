//
//  UserViewModel.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 11/27/24.
//
// ViewModels/UserViewModel.swift
// UserViewModel.swift
import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    private let databaseManager = DatabaseManager.shared
    
    // SignIn method
    func signInUser(username: String, password: String, completion: @escaping (Bool, Int64?) -> Void) {
        if let user = databaseManager.fetchUserByUsername(username: username) {
            if user.password == password {
                self.isAuthenticated = true
                self.user = user
                self.errorMessage = ""
                completion(true, user.userId)  // Pass user.id here
            } else {
                self.errorMessage = "Incorrect password"
                completion(false, nil)  // Failed login due to incorrect password
            }
        } else {
            self.errorMessage = "User not found"
            completion(false, nil)  // Failed login due to user not found
        }
    }

    
    // SignUp method
    func signUpUser(username: String, password: String) {
        // Check if username already exists
        if let existingUser = databaseManager.fetchUserByUsername(username: username) {
            self.errorMessage = "Username is already taken."
        } else {
            // If not, create a new user and insert into the database
            let userId = Int64.random(in: 1000...9999)  // Random userId for demo
            let newUser = User(userId: userId, username: username, email: "", password: password, displayPhoto: nil)
            databaseManager.insertUser(user: newUser)
            self.user = newUser
            self.isAuthenticated = true
            self.errorMessage = ""
        }
    }
    
    func fetchUserByUsername(username: String) -> User? {
          return databaseManager.fetchUserByUsername(username: username)
      }
}
