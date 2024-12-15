// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var userId = ""
    @State private var isRegistering = false  // Track whether the user is on the registration screen
    @State private var showAlert = false
    @State private var isLoggedIn = false  // Track the login state
     @State private var loggedInUsername = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo2") // Assuming the logo is in your Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(height: 30)
                
                if isRegistering {
                    // Registration Fields
                    VStack(spacing: 20) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            .padding(.horizontal)
                        
                        Button(action: {
                            userViewModel.signUpUser(username: username, password: password)
                            if userViewModel.errorMessage.isEmpty || !username.isEmpty || !password.isEmpty{
                                showAlert = true
                                username = ""
                                password = ""
                            }
                        }) {
                            Text("Register")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                                        startPoint: .topLeading,  // Starting point of the gradient
                                        endPoint: .bottomTrailing  // Ending point of the gradient
                                    )
                                )
                                .cornerRadius(10)
                        }
                        
                        // Show error message if registration fails
                        if !userViewModel.errorMessage.isEmpty {
                            Text(userViewModel.errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        // Show success alert when registration is successful
                        Alert(
                            title: Text("Success"),
                            message: Text("User registered successfully!"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                } else {
                    // Login Fields
                    VStack(spacing: 20) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            .padding(.horizontal)
                        
                        Button(action: {
                            userViewModel.signInUser(username: username, password: password) { success, userId in
                                                           if success, let userId = userId {
                                                               // Store the userId in UserDefaults after successful login
                                                               UserDefaults.standard.set(userId, forKey: "loggedInUserId")
                                                               print("User ID Stored: \(userId)") // Check if it's being stored correctly
                                                               
                                    isLoggedIn = true
                                    loggedInUsername = username
                                    username = ""
                                    password = ""
                                } else {
                               
                                    showAlert = true
                                }
                            }
                        }) {
                            Text("Login")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                                    startPoint: .topLeading,  // Starting point of the gradient
                                    endPoint: .bottomTrailing  // Ending point of the gradient
                                ))
                                .cornerRadius(10)
                        }
                        
                        // Show error message if login fails
                        if !userViewModel.errorMessage.isEmpty {
                            Text(userViewModel.errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        Button(action: {
                            isRegistering.toggle()  // Switch to registration view
                        }) {
                            Text("Not a user? Register")
                                .font(.body)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                                        startPoint: .topLeading,  // Starting point of the gradient
                                        endPoint: .bottomTrailing  // Ending point of the gradient
                                    )
                                )

                            
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        // Show error message when login fails
                        Alert(
                            title: Text("Login Failed"),
                            message: Text(userViewModel.errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)  // Optional: Hide navigation bar on the login page
            .background(
                NavigationLink(destination: UserPage(username: loggedInUsername,isLoggedIn: $isLoggedIn), isActive: $isLoggedIn) {
                EmptyView()  // This is a "hidden" NavigationLink that
                }
            )
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
