//
//
//import SwiftUI
//
//struct HomeView: View {
//    @State private var selectedTab: Int = 0
//    @State private var totalBalance: Double = 500.0  // Total balance (what you owe or are owed)
//    @State private var debtAmount: Double = 200.0  // Example of amount owed (debt)
//    @State private var collectionAmount: Double = 150.0  // Example of amount to collect (collection)
//    @State private var expenses: [Expense] = [] // Store fetched expenses
//    @State private var splits: [ExpenseSplit] = []
//    private var dbManager = DatabaseManager.shared
//    var userId: Int64 {
//        return UserDefaults.standard.object(forKey: "loggedInUserId") as? Int64 ?? 0  // Default to 0 if not found
//    }
//    
//    var netAmount: Double {
//        return collectionAmount - debtAmount
//    }
//    
//    var percentage: Double {
//        return (debtAmount / totalBalance) * 100
//    }
//    
//    // Fetch expenses when the view appears
//    func fetchExpenses() {
//        self.expenses = DatabaseManager.shared.fetchExpenses(forUserId: userId)
//        self.splits = DatabaseManager.shared.fetchSplits(forUserId: userId)
//        calculateAmounts()
//    }
//
//    func calculateAmounts() {
//        debtAmount = 0.0  // Reset the debt amount (what the user owes)
//        collectionAmount = 0.0  // Reset the collection amount (what others owe the user)
//        
//        // Fetch all the expenses for the logged-in user
//        let expenses = DatabaseManager.shared.fetchExpenses()
//        
//        // Loop through each expense to determine amounts to pay or collect
//        for expense in expenses {
//            // Debugging: Check if expense.payerId and userId match
//            print("Expense ID: \(expense.id), Payer ID: \(expense.payerId), Logged-in User ID: \(userId)")
//
//            let expenseSplits = DatabaseManager.shared.fetchSplits(forExpenseId: expense.id)
//            
//            // Loop through each split to check how much the logged-in user owes or is owed
//               for split in expenseSplits {
//                   print("Split: User ID \(split.userId), Amount: \(split.amount)")
//
//                   // Check if the logged-in user is the payer
//                   if expense.payerId == userId {
//                       // The logged-in user is the payer
//                       if split.userId != userId {
//                           collectionAmount += split.amount  // Others owe this amount to the logged-in user
//                           print("Added to collectionAmount: \(split.amount), Total Collection Amount: \(collectionAmount)")
//                       }
//                   } else {
//                       // The logged-in user is NOT the payer
//                       if split.userId == userId {
//                           debtAmount += split.amount  // The logged-in user owes this amount
//                           print("Added to debtAmount: \(split.amount), Total Debt Amount: \(debtAmount)")
//                       }
//                   }
//               }
//           }
//
//        // Debug output to ensure correct calculations
//        print("Debt Amount: \(debtAmount)")
//        print("Collection Amount: \(collectionAmount)")
//    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            VStack(alignment: .leading) {
//                VStack(spacing: 15) {
//                    VStack(alignment: .leading) {
//                        Text("To Pay")
//                            .font(.headline)
//                            .padding(.horizontal, 10)
//                        
//                        ZStack {
//                            ProgressView("", value: min(debtAmount, totalBalance), total: totalBalance)
//                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
//                                .frame(height: 20)
//                                .padding(.horizontal)
//                        }
//                    }
//                    VStack(alignment: .leading) {
//                        Text("Get Paid")
//                            .font(.headline)
//                            .padding(.horizontal, 10)
//                        
//                        ZStack {
//                            ProgressView("", value: min(collectionAmount, totalBalance), total: totalBalance)
//                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
//                                .frame(height: 20)
//                                .padding(.horizontal)
//                        }
//                    }
//                }
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
//                .shadow(radius: 5)
//                .padding(.horizontal)
//            }
//            .offset(y: 20)
//            
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("Net Balance")
//                        .font(.headline)
//                        .padding(.horizontal, 10)
//                    
//                    Spacer()
//                    
//                    // Use CurrencyManager to convert netAmount to the selected currency
//                    let convertedNetAmount = CurrencyManager.shared.convertAmount(netAmount)
//                    Text("\(CurrencyManager.shared.selectedCurrencySymbol())\(String(format: "%.2f", convertedNetAmount))")
//                        .font(.title)
//                        .foregroundColor(convertedNetAmount >= 0 ? .green : .red)
//                        .bold()
//                        .padding(.horizontal)
//                        .padding(.top, 5)
//                }
//            }
//            .padding(.top, 10)
//            
//            VStack(alignment: .leading, spacing: 13) {
//                Text("Your Expenses")
//                    .font(.title2)
//                    .bold()
//                    .padding(.horizontal, -10)
//                
//                // Display user expenses dynamically
//                if expenses.isEmpty {
//                    Text("Loading expenses...")
//                        .foregroundColor(.gray)
//                        .italic()
//                        .padding(.horizontal)
//                } else {
//                    ForEach(expenses) { expense in
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text(expense.description)
//                                    .font(.headline)
//                                Spacer()
//                                
//                                // Convert expense amount to selected currency
//                                let convertedAmount = CurrencyManager.shared.convertAmount(expense.amount)
//                                Text("\(CurrencyManager.shared.selectedCurrencySymbol())\(String(format: "%.2f", convertedAmount))")
//                                    .font(.subheadline)
//                                    .foregroundColor(convertedAmount >= 0 ? .green : .red)
//                            }
//                            
//                            Divider()
//                        }
//                        .padding(.horizontal)
//                        .padding(.top, 10)
//                    }
//                    .onDelete(perform: deleteExpense)
//                    
//                }
//            }
//            
//            .padding(.horizontal)
//            .padding(.top, 8)
//            
//            Spacer()
//        }
//        .background(Color(UIColor.systemBackground))
//        .edgesIgnoringSafeArea(.all)
//        .onAppear {
//            fetchExpenses()  // Fetch expenses for the user when the view appears
//        }
//       
//    }
//    private func deleteExpense(at offsets: IndexSet) {
//        // Remove from the database
//        offsets.forEach { index in
//            let expense = expenses[index]
//            DatabaseManager.shared.deleteExpense(expense: expense)
//        }
//
//        // Remove from the local array to update the UI
//        expenses.remove(atOffsets: offsets)
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int = 0
    @State private var totalBalance: Double = 35500.0
    @State private var debtAmount: Double = 200.0
    @State private var collectionAmount: Double = 150.0
    @State private var expenses: [Expense] = []  // Store fetched expenses
    @State private var splits: [ExpenseSplit] = []
    @State private var showDebtAmount: Bool = false
        @State private var showCollectionAmount: Bool = false
    private var dbManager = DatabaseManager.shared
    var userId: Int64 {
        return UserDefaults.standard.object(forKey: "loggedInUserId") as? Int64 ?? 0  // Default to 0 if not found
    }
    
    var netAmount: Double {
        return collectionAmount - debtAmount
    }
    
    var percentage: Double {
        return (debtAmount / totalBalance) * 100
    }
    
    // Fetch expenses when the view appears
    func fetchExpenses() {
        self.expenses = DatabaseManager.shared.fetchExpenses(forUserId: userId)
        self.splits = DatabaseManager.shared.fetchSplits(forUserId: userId)
        calculateAmounts()
    }

    func calculateAmounts() {
        debtAmount = 0.0  // Reset the debt amount
        collectionAmount = 0.0  // Reset the collection amount
        
        let expenses = DatabaseManager.shared.fetchExpenses()
        
        for expense in expenses {
            print("Expense ID: \(expense.id), Payer ID: \(expense.payerId), Logged-in User ID: \(userId)")

            let expenseSplits = DatabaseManager.shared.fetchSplits(forExpenseId: expense.id)
            
            for split in expenseSplits {
                print("Split: User ID \(split.userId), Amount: \(split.amount)")

                // If the logged-in user is the payer
                if expense.payerId == userId {
                    if split.userId != userId {
                        collectionAmount += split.amount
                    }
                } else {
                    if split.userId == userId {
                        debtAmount += split.amount
                    }
                }
            }
        }

        print("Debt Amount: \(debtAmount)")
        print("Collection Amount: \(collectionAmount)")
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading) {
                        Text("To Pay")
                            .font(.headline)
                            .foregroundColor(.white)  // White text for contrast
                            .padding(.horizontal, 10)
                        
                        GeometryReader { geometry in
                            ZStack {
                                HStack(spacing: 0) {
                                    // Red section (Debt Amount)
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: CGFloat(debtAmount / 10000) * geometry.size.width)
                                        .onHover { hovering in
                                            showDebtAmount = hovering  // Show the debt amount when hovering
                                        }
                                        .onTapGesture {
                                            showDebtAmount.toggle()  // Toggle the display on tap (iOS)
                                                                        }
                                    
                                    // Gray section (Remaining Amount)
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: CGFloat((10000 - debtAmount) / 10000) * geometry.size.width)
                                }
                                .frame(height: 20)  // Set the height of the progress bar
                                .cornerRadius(10)  // Rounded corners
                                .padding(.horizontal, 10)
                                
                                if showDebtAmount {
                                    Text("\(Int(debtAmount))")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(5)
                                        .position(x: geometry.size.width * CGFloat(debtAmount / 10000), y: 10)
                                }
                            }
                        }
                    }
                    
                    // Get Paid Section (Collection Amount Progress)
                    VStack(alignment: .leading) {
                        Text("Get Paid")
                            .font(.headline)
                            .foregroundColor(.white) // White text for contrast
                            .padding(.horizontal, 10)
                        
                        GeometryReader { geometry in
                            ZStack {
                                HStack(spacing: 0) {
                                    // Green section (Collection Amount)
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: CGFloat(collectionAmount / 10000) * geometry.size.width)
                                        .onHover { hovering in
                                            showCollectionAmount = hovering  // Show the collection amount when hovering
                                        }
                                        .onTapGesture {
                                            showCollectionAmount.toggle()  // Toggle the display on tap (iOS)
                                                                       }
                                    
                                    // Gray section (Remaining Amount)
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: CGFloat((10000 - collectionAmount) / 10000) * geometry.size.width)
                                }
                                .frame(height: 20)  // Set the height of the progress bar
                                .cornerRadius(10)  // Rounded corners
                                .padding(.horizontal, 10)
                                
                                if showCollectionAmount {
                                    Text("\(Int(collectionAmount))")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(5)
                                        .position(x: geometry.size.width * CGFloat(collectionAmount / 10000), y: 10)
                                }
                            }
                        }
                    }
                }
                .padding() // Padding around the card
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)) // Gradient background for the card
                .cornerRadius(15) // Rounded corners for the card
                .shadow(radius: 10, x: 0, y: 5) // Shadow for depth
                .padding(.horizontal) // Horizontal padding around the card
            }

            .offset(y: 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Net Balance")
                        .font(.headline)
                        .padding(.horizontal, 10)
                        .foregroundColor(.purple)
                    
                    Spacer()
                    
                    let convertedNetAmount = CurrencyManager.shared.convertAmount(netAmount)
                    Text("\(CurrencyManager.shared.selectedCurrencySymbol())\(String(format: "%.2f", convertedNetAmount))")
                        .font(.title)
                        .foregroundColor(convertedNetAmount >= 0 ? .green : .red)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top, 5)
                }
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 13) {
                Text("Recent Expenses")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, -10)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                            startPoint: .topLeading,  // Starting point of the gradient
                            endPoint: .bottomTrailing  // Ending point of the gradient
                        )
                    )

                
                if expenses.isEmpty {
                    Text("No expenses")
                        .foregroundColor(.gray)
                        .italic()
                        .padding(.horizontal)
                } else {
                    List {
                        ForEach(expenses) { expense in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(expense.description)
                                        .font(.headline)
                                    Spacer()
                                    
                                    let convertedAmount = CurrencyManager.shared.convertAmount(expense.amount)
                                    Text("\(CurrencyManager.shared.selectedCurrencySymbol())\(String(format: "%.2f", convertedAmount))")
                                        .font(.subheadline)
                                        .foregroundColor(convertedAmount >= 0 ? .green : .red)
                                }
                                Divider()
                                    .background(Color.blue)
                            }
                            .padding(.horizontal, 10) // Only padding here for the list item
                            .padding(.top, 10)
                            .swipeActions {
                                                // "Settle" Action (green color)
                                                Button(action: {
                                                    // Perform the delete action (we're using deleteExpense here for consistency)
                                                    if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
                                                        deleteExpense(at: IndexSet([index]))
                                                    }
                                                }) {
                                                    Label("Settle", systemImage: "checkmark.circle.fill")
                                                }
                                                .tint(.green)  // Green color for settle action
                                                
                                                // Default Delete Action (can still be used for traditional delete)
                                                Button(role: .destructive, action: {
                                                    if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
                                                        deleteExpense(at: IndexSet([index]))
                                                    }
                                                }) {
                                                    Label("Delete", systemImage: "trash.fill")
                                                }
                                                .tint(.red)  // Red color for delete action
                                            }
                                        }
                        
                        .onDelete(perform: deleteExpense)
                    }
                    .listStyle(PlainListStyle())  // Remove default list styling (no gray background)
                    .padding(.top, 10) // Add top padding to the List, but not inside the items
                }
            }
            
            .padding(.horizontal)
            .padding(.top, 8)
            
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            fetchExpenses()  // Fetch expenses when the view appears
        }
    }
    
    private func deleteExpense(at offsets: IndexSet) {
        offsets.forEach { index in
            let expense = expenses[index]
            DatabaseManager.shared.deleteExpense(expense: expense)
        }

        expenses.remove(atOffsets: offsets)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
