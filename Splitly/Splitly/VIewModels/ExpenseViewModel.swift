//import SwiftUI
//
//class ExpenseViewModel: ObservableObject {
//    private let databaseManager = DatabaseManager.shared
//    @Published var users: [User] = []
//    @Published var selectedPaidBy: User?
//    @Published var selectedParticipants: [User] = []
//    @Published var expenseDescription: String = ""
//    @Published var expenseAmount: String = ""
//    @Published var category: String = "Food"
//    
//    init() {
//        fetchUsers()
//    }
//    
//    // Fetch all users from the database
//    func fetchUsers() {
//        self.users = databaseManager.fetchUsers()
//    }
//    
//    // Calculate the amount each participant needs to pay
//    func calculateSplitAmounts() -> [User: Double] {
//        guard let amount = Double(expenseAmount), amount > 0 else {
//            return [:]
//        }
//        
//        let totalParticipants = Double(selectedParticipants.count + 1) // Including the payer
//        let perPersonAmount = amount / totalParticipants
//        var splitAmounts: [User: Double] = [:]
//        
//        // Assign the calculated amount to each participant
//        for participant in selectedParticipants {
//            splitAmounts[participant] = perPersonAmount
//        }
//        
//        // The payer does not owe anything
//        if let payer = selectedPaidBy {
//            splitAmounts[payer] = 0
//        }
//        
//        return splitAmounts
//    }
//    
//    // Save expense to the database
//    func saveExpense() {
//        guard let paidBy = selectedPaidBy else { return }
//        
//        let expense = Expense(
//            amount: Double(expenseAmount) ?? 0,
//            description: expenseDescription,
//            category: category,
//            payerId: paidBy.id,
//            participants: selectedParticipants
//        )
//        
//        databaseManager.saveExpense(expense)
//    }
//}
