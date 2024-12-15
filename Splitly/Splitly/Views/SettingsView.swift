import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var notificationsEnabled: Bool = true // Toggle for notifications
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    @Environment(\.presentationMode) var presentationMode
    @State private var showingLogoutAlert = false
    @Binding var isLoggedIn: Bool
    @State private var userName: String = "John Doe" // User name
    @State private var userEmail: String = "john.doe@example.com" // User email
    let availableCurrencies = ["INR", "USD", "EUR", "GBP"]
      
      // Currency symbols mapping
      let currencySymbols = [
          "INR": "₹",
          "USD": "$",
          "EUR": "€",
          "GBP": "£"
      ]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Currency Settings")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                            startPoint: .topLeading,  // Starting point of the gradient
                            endPoint: .bottomTrailing  // Ending point of the gradient
                        )
                    )) {
                                   Picker("Select Currency", selection: $selectedCurrency) {
                                       ForEach(availableCurrencies, id: \.self) { currency in
                                           Text(currency)
                                       }
                                   }
                                   .pickerStyle(MenuPickerStyle())
                                
                                      
                                                         
                               }                // Notification Section
              
                
                // Theme Section
                Section(header: Text("Theme")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                            startPoint: .topLeading,  // Starting point of the gradient
                            endPoint: .bottomTrailing  // Ending point of the gradient
                        )
                    )) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                    .onChange(of: isDarkMode) { value in
                        // Save the dark mode setting to UserDefaults
                        UserDefaults.standard.set(value, forKey: "isDarkMode")
                        
                        // Apply the dark mode setting immediately
                        if value {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                        } else {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                        }
                    }

                }

                // Manage Groups Section
                Section(header: Text("Manage Groups")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                            startPoint: .topLeading,  // Starting point of the gradient
                            endPoint: .bottomTrailing  // Ending point of the gradient
                        )
                    )) {
                    NavigationLink(destination: GroupView()) {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("View and Edit Groups")
                        }
                    }
                }
                
                // Help & Support Section
                Section(header: Text("Help & Support")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                            startPoint: .topLeading,  // Starting point of the gradient
                            endPoint: .bottomTrailing  // Ending point of the gradient
                        )
                    )) {
                    Button(action: {
                        // Action to show help and support page
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Help & Support")
                        }
                    }
                }
                // Logout Section
                Section {
                    Button(action: {
                             // Show the logout confirmation alert
                             showingLogoutAlert = true
                         }) {
                             HStack {
                                 Image(systemName: "arrow.right.circle.fill")
                                     .foregroundColor(.red)  // Red color for the icon
                                 
                                 Text("Logout")
                                     .font(.headline)
                                     .foregroundColor(.red)  // Red color for the text
                             }
                             .padding()  // Padding around the content
                             .background(Color.white)  // White background for contrast
                             .cornerRadius(10)  // Rounded corners
                             .shadow(radius: 5)  // Optional: Add shadow for depth
                         }
                     
                           }
                .alert(isPresented: $showingLogoutAlert) {
                          Alert(
                              title: Text("Are you sure you want to log out?"),
                              message: Text("You will be logged out of your account."),
                              primaryButton: .destructive(Text("Log Out"), action: {
                                  // Perform the logout action
                                  isLoggedIn = false
                              }),
                              secondaryButton: .cancel()
                          )
                      }

            }
            .background(Color(UIColor.systemBackground))
        }
        .background(Color(UIColor.systemBackground))
    }
    private func handleLogout() {
          // Dismiss the current view and navigate back to ContentView
          presentationMode.wrappedValue.dismiss() // Dismiss this view (SettingsView)
          
          // Optionally hide the navigation bar on the previous view
          // Since this is in the SettingsView, the navigation bar should already be hidden
          // But, you can force a hide when returning by applying the modifier to the previous screen.
      }
}

////struct SettingsView_Previews: PreviewProvider {
////    static var previews: some View {
////        SettingsView(isLoggedIn: $isLoggedIn)
////    }
//}
