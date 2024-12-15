import SwiftUI

struct ActivityView: View {
    @State private var expenses: [Expense] = []
    @State private var categories: [Int64: String] = [:] // To store category names by ID
    var userId: Int64 {
        return UserDefaults.standard.object(forKey: "loggedInUserId") as? Int64 ?? 0  // Default to 0 if not found
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("")
                    .font(.title)
                    .bold()
                    .padding(.top, 10) // Reduce the top padding to avoid extra space
                
                // ScrollView for the activity feed (can be populated with activities later)
                ScrollView {
                    VStack(spacing: 15) {
                        // You can display activities here if needed
                    }
                }
                
                // Show the category expense chart if there are expenses
                if !expenses.isEmpty {
                    CategoryExpenseChartView(expenses: expenses, categories: categories)
                        .frame(height: 300) // Set a fixed height for the chart
                        .padding(.bottom, 200) // Add a bit of top padding for better spacing
                }

                Spacer()
            }
            .padding([.leading, .trailing]) // Adjust side padding if needed
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                loadExpenses(forUserId: userId)  // Example userId = 1, replace with real logic
            }
        }
    }

    // Function to load expenses and categories
    private func loadExpenses(forUserId userId: Int64) {
        // Fetch expenses for the user
        let fetchedExpenses = DatabaseManager.shared.fetchExpenses(forUserId: userId)
        expenses = fetchedExpenses
        
        // Map the categoryId to category name
        var categoryDict = [Int64: String]()
        for expense in fetchedExpenses {
            if let category = DatabaseManager.shared.fetchCategoryById(categoryId: expense.categoryId) {
                categoryDict[expense.categoryId] = category.categoryName
            }
        }
        categories = categoryDict
    }
}

