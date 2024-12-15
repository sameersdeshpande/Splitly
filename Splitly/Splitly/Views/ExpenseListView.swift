import SwiftUI



struct ExpenseListView: View {
    @Binding var groupId: Int64?  // The passed groupId
    var participants: [String]  // The participants array
    @State private var userBalance: Double = 0.0
    @State private var groupExpenses: [GroupExpense] = []  // Array of group expenses
    @State private var groupSplits: [GroupExpenseSplit] = []
    let databaseManager = DatabaseManager.shared
    var userId: Int64 {
         return UserDefaults.standard.object(forKey: "loggedInUserId") as? Int64 ?? 0  // Default to 0 if not found
     }

    func fetchExpenses() {
        // Fetch all group expenses from the database (ensure it's an array)
        let allGroupExpenses = databaseManager.fetchAllGroupExpenses()

        // Filter the expenses based on the groupId passed to this view
        groupExpenses = allGroupExpenses.filter { expense in
            expense.groupId == groupId  // Match groupId with the passed groupId
        }
        fetchExpensesAndSplits()
    }
   
    func fetchExpensesAndSplits() {
        guard let groupId = groupId else { return }
        
        // Fetch the expenses and splits from the DatabaseManagerx
        groupExpenses = databaseManager.fetchExpenses(for: groupId)
        groupSplits = databaseManager.fetchSplits(for: groupId)
        
        // Calculate the balance for the logged-in user
        let loggedInUserId = databaseManager.getLoggedInUserId()
        userBalance = databaseManager.calculateBalance(for: groupId, userId: loggedInUserId)
    }
  
    var body: some View {
        VStack {
            if userBalance < 0 {
                 Text("You Owe: ₹\(abs(userBalance), specifier: "%.2f")")
                     .foregroundColor(.red)
             } else {
                 Text("To Collect: ₹\(userBalance, specifier: "%.2f")")
                     .foregroundColor(.green)
             }

            if groupExpenses.isEmpty {
                Text("No expenses found for this group.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                List(groupExpenses, id: \.id) { expense in
                    VStack(alignment: .leading) {
                        Text(expense.description)  // Use groupName instead of description
                            .font(.headline)

                        Text("Amount: ₹\(expense.amount, specifier: "%.2f")")
                            .font(.subheadline)
                      var payername =  databaseManager.fetchUsername(for: expense.payerId)
                        if let unwrappedPayerName = payername {
                            Text("Paid By: \(unwrappedPayerName)")
                                .font(.subheadline)
                        } else {
                            Text("Paid By: Unknown User")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
              
            }

            // Add Expense Button (Now inside the VStack)
            NavigationLink(
                destination: GroupExpenseDetailView(
                    groupId: $groupId,  // Pass the groupId to the destination view
                    participants: participants  // Pass participants to the destination view
                ),
                label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Add Group Expense")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            )
            .padding(.top)
        }
        .background(Color(UIColor.systemBackground))
        .onAppear {
            fetchExpenses()  // Fetch and filter the expenses when the view appears
        }
        .navigationTitle("Group Expenses")
        .background(Color(UIColor.systemBackground))
    }
    
    
 
}


