import SwiftUI

struct AddExpenseView: View {
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var categoryId: Int64 = 0
    @State private var payerId: Int64 = 0
    @State private var selectedParticipants: [Int64] = []
    @State private var customSplitAmounts: [Int64: Double] = [:]
    @State private var splitAmounts: [Int64: Double] = [:]
    @State private var allUsers: [User] = []  // List of all users
    @State private var categories: [(Int64, String)] = [] // Array of tuples
    @State private var selectedPayer: User?
    @State private var participants: [User] = []
    @Environment(\.presentationMode) var presentationMode  // For dismissing view after saving
    
    // Reference to the database manager
    private var dbManager = DatabaseManager.shared
    

    
    @State private var showSplitAmountSheet = false  // Controls showing the split sheet
    
    var body: some View {
        VStack(spacing: 20) {
            // Existing UI components (Expense description, amount, category, payer, etc.)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "text.justify") // Icon for description
                        .foregroundColor(.blue)
                    TextField("Description", text: $description)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                }
                .padding(.horizontal)
            }
            
            // Amount with currency symbol
            VStack(alignment: .leading) {
                HStack {
                    Text(CurrencyManager.shared.selectedCurrencySymbol())
                        .font(.title)
                        .foregroundColor(.blue)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "tag.fill") // Category icon
                            .foregroundColor(.blue)   // Icon color
                            .font(.title2)
                        
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer() // Pushes the Picker to the right
                    
                    // Category Picker aligned to the right
                 
                    Picker("Category", selection: $categoryId) {
                                      ForEach(categories, id: \.0) { category in  // Use the tuple (categoryId, categoryName)
                                          Text(category.1)  // Display category name
                                              .tag(category.0)  // Bind the categoryId to the selection
                                      }
                                  }
                        .pickerStyle(MenuPickerStyle()) // Use dropdown style
                        .padding(10) // Add padding inside the Picker
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        .frame(height: 30) // Set height for the picker to make it smaller
                }
                .padding(.horizontal) // Add padding for the entire HStack
            }
            .padding(.top, 10) // Add top padding for spacing
            
                        VStack(alignment: .leading) {
                            HStack {
                                // Paid By Icon and Label
                                HStack(spacing: 5) {
                                    Image(systemName: "person.fill") // Icon for "Paid By"
                                        .foregroundColor(.blue)   // Icon color
                                        .font(.title2)
            
                                    Text("Paid By")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
            
                                Spacer() // Pushes the Picker to the right
            
                                // Paid By Picker
                                Picker("Paid By", selection: $payerId) {
                                                   ForEach(allUsers, id: \.userId) { user in
                                                       Text(user.username)  // Display username
                                                           .tag(user.userId)  // Bind the userId to the selection
                                                   }
                                               }
                                .pickerStyle(MenuPickerStyle()) // Use dropdown style
                                .padding(10) // Add padding inside the Picker
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .frame(height: 30) // Set height for the picker to make it smaller
                            }
                            .padding(.horizontal) // Add padding for the entire HStack
                        }
                        .padding(.top, 10) // Add top padding for spacing
  
            // Button to open the Split Amount sliding view (this opens the bottom sheet/modal)
            Button(action: {
                showSplitAmountSheet.toggle()  // Trigger sheet
            }) {
                Text("Split")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green) // Set the button background color
                    .frame(height: 40)
                    .cornerRadius(10)
            }
            .padding(.leading, 290) // Align to the left (add padding to left)
            .padding(.top, 10)
            
            // Action buttons (Submit or Cancel)
            Button(action: {
                       // Ensure a valid amount
                       guard let totalAmount = Double(amount), totalAmount > 0 else { return }
                       
                       // Create the Expense object
                       let expense = Expense(
                           id: 0,
                           amount: totalAmount,
                           description: description,
                           categoryId: categoryId,
                           payerId: payerId,
                           customSplitAmounts: customSplitAmounts
                       )
                       
                       // Save the expense and splits to the database
                       dbManager.saveExpense(expense: expense)
                   }) {
                       Text("Add Expense")
                           .foregroundColor(.white)  // White text color
                           .padding()
                         
                           .background(
                               LinearGradient(
                                   gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                                   startPoint: .topLeading,  // Starting point of the gradient
                                   endPoint: .bottomTrailing // Ending point of the gradient
                               )
                           )
                           .cornerRadius(10)
                           .shadow(radius: 5)  // Optional: Add a shadow for depth

            }
            .padding(.top,130)
            
            Spacer()
        }
        .navigationBarTitle("Add Expense", displayMode: .inline)
        .padding(.top, 20)
        .onAppear {
                   // Fetch categories when the view appears
            self.categories = dbManager.fetchCategories()
            self.allUsers = dbManager.fetchUsers()
        }
        .sheet(isPresented: $showSplitAmountSheet) {
            // Pass onDismiss closure to handle dismissal
            SplitAmountView(participants: allUsers, splitAmounts: $customSplitAmounts, onDismiss: {
                self.showSplitAmountSheet = false  // This will dismiss the sheet
            })
        }
    }
    
}

struct SplitAmountView: View {
    var participants: [User]  // List of participants (users)
    @Binding var splitAmounts: [Int64: Double]  // Dictionary binding for split amounts: userId -> amount
    var onDismiss: () -> Void  // Closure to dismiss the view when done

    var body: some View {
        VStack {
            Text("Custom Split Amount")
                .font(.headline)
                .padding()

            // Loop through participants (users) to display each user and their split input
            ForEach(participants, id: \.userId) { user in
                HStack {
                    Text(user.username)  // Display the participant's username
                        .frame(width: 150, alignment: .leading)

                    // Binding the split amounts: ensure it's initialized to 0 if not set
                    TextField("Amount", value: Binding(
                        get: {
                            // Provide default value if not present in the dictionary
                            self.splitAmounts[user.userId] ?? 0.0
                        },
                        set: { newValue in
                            // Update the dictionary with the new split amount
                            self.splitAmounts[user.userId] = newValue
                        }
                    ), formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                    .frame(width: 100)
                }
            }

            Button(action: {
                // Call the onDismiss closure to close the view
                onDismiss()
            }) {
                Text("Done")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}



struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
