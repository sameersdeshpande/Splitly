import SQLite
import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    // Path to the database file
    private var db: Connection!
    
    // Tables
    private var usersTable: Table!
    private var categoriesTable: Table!
    private var expensesTable: Table!
    private var expenseSplitsTable: Table! // New table to store participants
    private var groupsTable: Table!
    private var groupExpensesTable: Table!
    private var groupExpenseSplitsTable: Table!
    // Columns for users
    private var userId: Expression<Int64>!
    private var username: Expression<String>!
    private var password: Expression<String>!
    private var email: Expression<String>!
    private var displayPhoto: Expression<String?>!
    
    // Columns for categories
    private var categoryId: Expression<Int64>!
    private var categoryName: Expression<String>!
    
    // Columns for expenses
    private var expenseId: Expression<Int64>!
    private var expenseAmount: Expression<Double>!
    private var expenseDescription: Expression<String>!
    private var expenseCategoryId: Expression<Int64>!  // Foreign key to category
    private var expensePayerId: Expression<Int64>!  // Payer ID
    
    private var expenseSplitExpenseId: Expression<Int64>!
    private var expenseSplitsId: Expression<Int64>!
    private var expenseSplitUserId: Expression<Int64>!
    private var expenseSplitAmount: Expression<Double>!
    
    private var groupId: Expression<Int64>!
    private var groupName: Expression<String>!
    private var groupAmount: Expression<Double>!
    
    private var groupExpenseId: Expression<Int64>!
    private var groupExpenseAmount: Expression<Double>!
    private var groupExpenseDescription: Expression<String>!
    private var groupExpenseGroupId: Expression<Int64>!  // Foreign key to the group
    private var groupExpensePayerId: Expression<Int64>!
    
    private var groupExpenseSplitId: Expression<Int64>!
    private var groupExpenseSplitExpenseId: Expression<Int64>!  // Foreign key to group expenses
    private var groupExpenseSplitUserId: Expression<Int64>!     // Foreign key to users
    private var groupExpenseSplitAmount: Expression<Double>!
    
    private var groupMembersTable = Table("group_members")
    private var groupMemberId: Expression<Int64>!
    private var groupIdRef: Expression<Int64>!  // Foreign key to the groups table
    private var userIdRef: Expression<Int64>!
    
    private init() {
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("splitly1.sqlite").path
            db = try Connection(path)
            print(path)
            
            // Set up the users table and columns
            usersTable = Table("users")
            userId = Expression<Int64>("userId")
            username = Expression<String>("username")
            password = Expression<String>("password")
            email = Expression<String>("email")
            displayPhoto = Expression<String?>("displayPhoto")
            
            // Set up the categories table and columns
            categoriesTable = Table("categories")
            categoryId = Expression<Int64>("categoryId")
            categoryName = Expression<String>("categoryName")
            
            expensesTable = Table("expenses")
            expenseId = Expression<Int64>("expenseId")
            expenseAmount = Expression<Double>("amount")
            expenseDescription = Expression<String>("description")
            expenseCategoryId = Expression<Int64>("categoryId")
            expensePayerId = Expression<Int64>("payerId")
            
            // Set up the expense_splits table and columns
            expenseSplitsTable = Table("expense_splits")
            expenseSplitsId = Expression<Int64>("splitId")
            expenseSplitExpenseId = Expression<Int64>("expenseId")  // Foreign key to expenses
            expenseSplitUserId = Expression<Int64>("userId")  // Foreign key to users
            expenseSplitAmount = Expression<Double>("splitAmount")
            // Create tables if they don't exist
            
            groupsTable = Table("groups")
            groupId = Expression<Int64>("groupId")
            groupName = Expression<String>("groupName")
            groupAmount = Expression<Double>("groupAmount")
            
            // Store member IDs as a comma-separated list
            
            // Create group expenses table
            groupExpensesTable = Table("group_expenses")
            groupExpenseId = Expression<Int64>("groupExpenseId")
            groupExpenseAmount = Expression<Double>("amount")
            groupExpenseDescription = Expression<String>("description")
            groupExpenseGroupId = Expression<Int64>("groupId")
            groupExpensePayerId = Expression<Int64>("payerId")
            
            // Create group expense splits table
            groupExpenseSplitsTable = Table("group_expense_splits")
            groupExpenseSplitId = Expression<Int64>("splitId")
            groupExpenseSplitExpenseId = Expression<Int64>("expenseId")
            groupExpenseSplitUserId = Expression<Int64>("userId")
            groupExpenseSplitAmount = Expression<Double>("splitAmount")
            
            // Initialize in the constructor
            groupMembersTable = Table("group_members")
            groupMemberId = Expression<Int64>("id")  // Primary key for group member entry
            groupIdRef = Expression<Int64>("ref_groupId")  // Foreign key to the groups table
            userIdRef = Expression<Int64>("ref_userId")
            
            try db.run(groupsTable.create(ifNotExists: true) { t in
                t.column(groupId, primaryKey: .autoincrement)
                t.column(groupName)
                t.column(groupAmount)
                
            })
            
            try db.run(groupExpensesTable.create(ifNotExists: true) { t in
                t.column(groupExpenseId, primaryKey: .autoincrement)
                t.column(groupExpenseAmount)
                t.column(groupExpenseDescription)
                t.column(groupExpenseGroupId)
                t.column(groupExpensePayerId)
            })
            
            try db.run(groupExpenseSplitsTable.create(ifNotExists: true) { t in
                t.column(groupExpenseSplitId, primaryKey: .autoincrement)
                t.column(groupExpenseSplitExpenseId)
                t.column(groupExpenseSplitUserId)
                t.column(groupExpenseSplitAmount)
                t.foreignKey(groupExpenseSplitExpenseId, references: groupExpensesTable, groupExpenseId)
                t.foreignKey(groupExpenseSplitUserId, references: usersTable, userId)
            })
            
            try db.run(usersTable.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: true)
                t.column(username, unique: true)
                t.column(password)
                t.column(email)
                t.column(displayPhoto)
            })
            
            try db.run(categoriesTable.create(ifNotExists: true) { t in
                t.column(categoryId, primaryKey: .autoincrement)  // Auto-increment primary key
                t.column(categoryName, unique: true)  // Ensure category names are unique
            })
            
            try db.run(expensesTable.create(ifNotExists: true) { t in
                t.column(expenseId, primaryKey: .autoincrement)
                t.column(expenseAmount)
                t.column(expenseDescription)
                t.column(expenseCategoryId)
                t.column(expensePayerId)
            })
            try db.run(groupMembersTable.create { t in
                t.column(groupIdRef) // Reference to the group
                t.column(userIdRef)  // Reference to the user
                t.foreignKey(groupIdRef, references: groupsTable, groupId) // Foreign key constraint
                t.foreignKey(userIdRef, references: usersTable, userId) // Foreign key constraint
            })
            try db.run(expenseSplitsTable.create(ifNotExists: true) { t in
                // Primary key for the split entry
                t.column(expenseSplitsId, primaryKey: .autoincrement)  // Auto-incrementing ID for each split
                
                // Foreign keys for expense and user
                t.column(expenseSplitExpenseId)  // Foreign key to expenses table (expenseId)
                t.column(expenseSplitUserId)     // Foreign key to users table (userId)
                t.column(expenseSplitAmount)     // Custom split amount for this user
                
                // Unique constraint to ensure each user can only have one split for an expense
                t.unique(expenseSplitExpenseId, expenseSplitUserId)  // Composite unique constraint
                
                // Foreign key constraints for referential integrity
                t.foreignKey(expenseSplitExpenseId, references: expensesTable, expenseId)
                t.foreignKey(expenseSplitUserId, references: usersTable, userId)
            })
            
            insertPredefinedCategories()
            print("Tables created successfully.")
        } catch {
            print("Database connection error: \(error)")
        }
    }
    
    // Fetch a user by username
    func fetchUserByUsername(username: String) -> User? {
        do {
            let query = usersTable.filter(self.username == username)
            if let userRow = try db.pluck(query) {
                let user = User(
                    userId: userRow[userId],
                    username: userRow[self.username],
                    email: userRow[email],
                    password: userRow[password],
                    displayPhoto: userRow[displayPhoto]
                )
                return user
            }
        } catch {
            print("Error fetching user: \(error)")
        }
        return nil
    }
    
    // Fetch all categories
    func fetchCategories() -> [(Int64, String)] {
        var categoriesList: [(Int64, String)] = []
        do {
            // Prepare a query to fetch category IDs and names from the categories table
            for category in try db.prepare(categoriesTable) {
                // Append a tuple of (categoryId, categoryName) to the categoriesList array
                let categoryId = category[categoryId]  // Assuming `categoryId` is of type Int64
                let categoryName = category[categoryName]  // Assuming `categoryName` is of type String
                categoriesList.append((categoryId, categoryName))
            }
        } catch {
            print("Error fetching categories: \(error)")
        }
        return categoriesList
    }
    
    func insertPredefinedCategories() {
        let predefinedCategories = [
            "Food",
            "Transport",
            "Entertainment",
            "Shopping",
            "Bills",
            "Other"
        ]
        
        // Safely unwrap the db connection before using it
        guard let db = db else {
            print("Database connection is not available")
            return
        }
        
        for category in predefinedCategories {
            // Check if the category already exists in the database
            let query = categoriesTable.filter(self.categoryName == category)
            
            do {
                // Check if the category already exists
                if try db.pluck(query) == nil {
                    // If category doesn't exist, insert it
                    try db.run(categoriesTable.insert(self.categoryName <- category))
                    print("Inserted category: \(category)")
                } else {
                    print("Category '\(category)' already exists.")
                }
            } catch {
                print("Error inserting category \(category): \(error)")
            }
        }
    }
    
    func fetchUsers() -> [User] {
        var usersList: [User] = []
        do {
            // Fetch all users from the usersTable
            for user in try db.prepare(usersTable) {
                // Create a User object for each user in the database
                let userId = user[userId]  // userId field
                let username = user[username]  // username field
                let email = user[email]  // email field
                let password = user[password]  // password field
                let displayPhoto = user[displayPhoto]  // Optional displayPhoto field
                
                let user = User(
                    userId: userId,
                    username: username,
                    email: email,
                    password: password,
                    displayPhoto: displayPhoto
                )
                
                usersList.append(user)
            }
        } catch {
            print("Error fetching users: \(error)")
        }
        return usersList
    }
    
    func fetchUserById(userId: Int64) -> User? {
        do {
            let query = usersTable.filter(self.userId == userId)
            
            if let userRow = try db.pluck(query) { // Get the first result from the query
                let user = User(
                    userId: userRow[self.userId],
                    username: userRow[self.username],
                    email: userRow[self.email],
                    password: userRow[self.password],
                    displayPhoto: userRow[self.displayPhoto]
                )
                return user
            }
        } catch {
            print("Error fetching user by ID: \(error)")
        }
        return nil
    }
    
    
    
    func fetchExpenses(forUserId userId: Int64) -> [Expense] {
        var expenses: [Expense] = []
        
        do {
            // Query expenses where the payerId matches the provided userId
            let expensesQuery = expensesTable.filter(expensePayerId == userId)
            let rows = try db.prepare(expensesQuery)
            
            // Map each row to an Expense object
            for row in rows {
                let expense = Expense(
                    id: row[expenseId],
                    amount: row[expenseAmount],
                    description: row[expenseDescription],
                    categoryId: row[expenseCategoryId],
                    payerId: row[expensePayerId]
                )
                expenses.append(expense)
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        return expenses  // Return the array of expenses
    }
    func deleteExpense(expense: Expense) {
          do {
              // Find the row that matches the given expense ID
              let expenseToDelete = expensesTable.filter(expenseId == expense.id)
              
              // Execute the delete operation
              try db.run(expenseToDelete.delete())
              print("Expense with ID \(expense.id) has been deleted.")
          } catch {
              print("Error deleting expense: \(error)")
          }
      }
    func fetchExpenses() -> [Expense] {
        var expenses: [Expense] = []
        
        do {
            // Check if the expensesTable is non-nil
            guard let expensesTable = expensesTable else {
                print("Error: expensesTable is nil.")
                return expenses
            }
            
            // Fetch all expenses from the expenses table (no user filter)
            let rows = try db.prepare(expensesTable)
            
            // Map each row to an Expense object
            for row in rows {
                let expense = Expense(
                    id: row[expenseId],
                    amount: row[expenseAmount],
                    description: row[expenseDescription],
                    categoryId: row[expenseCategoryId],
                    payerId: row[expensePayerId]
                )
                expenses.append(expense)
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        return expenses  // Return all expenses
    }

    func saveExpense(expense: Expense) {
        do {
            // Step 1: Insert the expense into the expenses table
            let insertExpense = expensesTable.insert(
                expenseAmount <- expense.amount,
                expenseDescription <- expense.description,
                expenseCategoryId <- expense.categoryId,
                expensePayerId <- expense.payerId
            )
            let expenseId = try db.run(insertExpense) // Get the auto-generated expense ID
            
            // Step 2: Insert the participants' splits into the expense_splits table
            for (userId, splitAmount) in expense.customSplitAmounts {
                if splitAmount > 0 { // Only save splits with a valid amount
                    let insertParticipant = expenseSplitsTable.insert(
                        expenseSplitExpenseId <- expenseId,
                        expenseSplitUserId <- userId,
                        expenseSplitAmount <- splitAmount
                    )
                    let expenseSplitsId = try db.run(insertParticipant) // Auto-generated splitId
                    print("Split saved with splitId: \(expenseSplitsId)")
                }
            }
            
            print("Expense and splits saved successfully")
            
        } catch {
            print("Error saving expense: \(error)")
        }
    }
    
    
    
    // Insert a new user into the database
    func insertUser(user: User) {
        do {
            let insert = usersTable.insert(
                username <- user.username,
                password <- user.password,
                email <- user.email,
                displayPhoto <- user.displayPhoto
            )
            try db.run(insert)
        } catch {
            print("Error inserting user: \(error)")
        }
    }
    
    func fetchCategoryById(categoryId: Int64) -> Category? {
        do {
            let query = categoriesTable.filter(self.categoryId == categoryId) // Filter by categoryId
            
            if let categoryRow = try db?.pluck(query) { // Get the first result from the query
                let category = Category(
                    categoryId: categoryRow[self.categoryId], // Get categoryId from the row
                    categoryName: categoryRow[self.categoryName] // Get categoryName from the row
                )
                return category
            }
        } catch {
            print("Error fetching category by ID: \(error)")
        }
        return nil
    }
    
    func fetchSplitAmounts(forExpenseId expenseId: Int64) -> [Int64: Double] {
        var splitAmounts: [Int64: Double] = [:]
        do {
            let query = expenseSplitsTable.filter(expenseSplitExpenseId == expenseId)
            for splitAmountRow in try db.prepare(query) {
                let userId = splitAmountRow[expenseSplitUserId]
                let amount = splitAmountRow[expenseSplitAmount]
                splitAmounts[userId] = amount
            }
        } catch {
            print("Error fetching split amounts: \(error)")
        }
        return splitAmounts
    }
    
    func addGroup(groupName: String, amount: Double, isOwed: Bool) throws -> Int64 {
        let groupsTable = Table("groups")
        let groupNameColumn = Expression<String>("groupName")
        let groupAmountColumn = Expression<Double>("amount")
        let groupIsOwedColumn = Expression<Bool>("isOwed")
        
        let insert = groupsTable.insert(
            groupNameColumn <- groupName,
            groupAmountColumn <- amount,
            groupIsOwedColumn <- isOwed
        )
        
        let groupId = try db.run(insert)
        return groupId
    }
    func createGroupWithMembers(groupName: String, amount: Double, userIds: [Int64]) throws -> Int64 {
        var groupId: Int64 = 0  // Declare a variable to hold the group ID
        
        // Insert the group into the groups table
        let insertGroup = groupsTable.insert(
            self.groupName <- groupName,
            self.groupAmount <- amount
        )
        
        // Save the groupId after the insert
        groupId = try db.run(insertGroup)
        
        // Add members to the group
        for userId in userIds {
            let insertMember = groupMembersTable.insert(
                self.groupIdRef <- groupId,
                self.userIdRef <- userId
            )
            try db.run(insertMember) // Insert each member into the group_members table
        }
        
        // After the transaction, return the groupId
        return groupId
    }
    func addGroupExpense(groupId: Int64, amount: Double, participants: [String]) throws {
        
    }
    
    
    func fetchGroupExpenses() -> [GroupExpenseSummary] {
        var groupExpenses: [GroupExpenseSummary] = []
        
        do {
            // Fetch all groups from the groups table
            let groups = try db.prepare(groupsTable)
            
            for groupRow in groups {
                let groupIdValue = groupRow[groupId]  // Get groupId
                let groupNameValue = groupRow[groupName]  // Get groupName
                let groupAmountValue = groupRow[groupAmount]  // Get groupAmount
                
                // Fetch participants for the current group from the group_members table
                let participantsQuery = groupMembersTable.filter(groupMembersTable[groupIdRef] == groupIdValue)
                
                var participants: [String] = []
                
                for participantRow in try db.prepare(participantsQuery) {
                    let userIdValue = participantRow[userIdRef]  // Get userId from group_members table
                    
                    // Fetch user name from the users table
                    let userQuery = usersTable.filter(usersTable[userId] == userIdValue)
                    if let userRow = try db.pluck(userQuery) {
                        let participantName = userRow[username]  // Correctly referencing the username column
                        participants.append(participantName)
                    }
                }
                
                // Add group expense summary
                let groupExpenseSummary = GroupExpenseSummary(
                    id: groupIdValue,
                    groupName: groupNameValue,
                    amount: groupAmountValue,
                    participants: participants
                )
                
                groupExpenses.append(groupExpenseSummary)
            }
        } catch {
            print("Error fetching group expenses: \(error)")
        }
        
        return groupExpenses
    }
    
    func fetchGroupExpenses(forUserId userId: Int64) -> [GroupExpenseSummary] {
        var groupExpenses: [GroupExpenseSummary] = []
        
        do {
            // Query the database to get groups where the user is a member
            let query = groupsTable
                .join(groupMembersTable, on: groupsTable[groupId] == groupMembersTable[groupIdRef])
                .filter(groupMembersTable[userIdRef] == userId)
            
            for groupRow in try db.prepare(query) {
                let groupId = groupRow[groupsTable[groupId]]
                let groupName = groupRow[groupsTable[groupName]]
                let groupAmount = groupRow[groupsTable[groupAmount]]
                
                // You can query further to get the participants and amount details
                
                // Example:
                let participants = getParticipantsForGroup(groupId: groupId)
                
                let groupExpense = GroupExpenseSummary(id: groupId, groupName: groupName, amount: groupAmount, participants: participants)
                groupExpenses.append(groupExpense)
            }
        } catch {
            print("Error fetching group expenses: \(error)")
        }
        
        return groupExpenses
    }
    
    // Fetch participants for a specific group
    func getParticipantsForGroup(groupId: Int64) -> [String] {
        var participants: [String] = []
        
        do {
            let query = groupMembersTable.filter(groupMembersTable[groupIdRef] == groupId)
            
            for member in try db.prepare(query) {
                let userId = member[groupMembersTable[userIdRef]]
                
                // Fetch the username from the users table using the userId
                if let userName = getUserNameForId(userId: userId) {
                    participants.append(userName)
                }
            }
        } catch {
            print("Error fetching participants: \(error)")
        }
        
        return participants
    }
    
    func fetchAllGroupExpenses() -> [GroupExpense] {
        var expenses: [GroupExpense] = []
        
        do {
            // Fetch all expenses
            for expenseRow in try db.prepare(groupExpensesTable) {
                let expenseId = expenseRow[groupExpenseId]
                var groupExpense = GroupExpense(
                    id: expenseId,
                    description: expenseRow[groupExpenseDescription],
                    amount: expenseRow[groupExpenseAmount],
                    groupId: expenseRow[groupExpenseGroupId],
                    payerId: expenseRow[groupExpensePayerId],
                    participants: [], // We'll populate this later
                    splitAmounts: [:] // We'll populate this later
                )
                
                // Now fetch the splits for this expense (using the expenseId)
                var splits: [Int64: Double] = [:]
                for splitRow in try db.prepare(groupExpenseSplitsTable.filter(groupExpenseSplitExpenseId == expenseId)) {
                    let userId = splitRow[groupExpenseSplitUserId]
                    let splitAmount = splitRow[groupExpenseSplitAmount]
                    splits[userId] = splitAmount
                }
                
                groupExpense.splitAmounts = splits
                expenses.append(groupExpense)
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        return expenses
    }
    
    
    
    // Helper function to get the username for a userId
    func getUserNameForId(userId: Int64) -> String? {
        do {
            let query = usersTable.filter(usersTable[self.userId] == userId)
            if let user = try db.pluck(query) {
                return user[username]
            }
        } catch {
            print("Error fetching user name: \(error)")
        }
        return nil
    }
    
    
    func fetchGroupById(groupId: Int64) -> String? {
        do {
            // Query the groups table for the group name where the group ID matches
            let groupQuery = groupsTable.filter(self.groupId == groupId)
            if let group = try db?.pluck(groupQuery) {
                return group[groupName] // Return the group name
            }
        } catch {
            print("Error fetching group name by ID: \(error)")
        }
        
        return nil // Return nil if the group is not found or an error occurs
    }
    
    func saveGroupExpense(expense: GroupExpense) {
        print("Saving expense: \(expense)")  // Log when the function is called
        
        do {
            let insertExpense = groupExpensesTable.insert(
                groupExpenseDescription <- expense.description,
                groupExpenseAmount <- expense.amount,
                groupExpenseGroupId <- expense.groupId,
                groupExpensePayerId <- expense.payerId
            )
            
            let groupExpenseId = try db.run(insertExpense)
            print("Group expense saved with ID: \(groupExpenseId)")  // Log the inserted ID
            
            // Optional: Insert splits into the group_expense_splits table
            for (userId, splitAmount) in expense.splitAmounts {
                let insertSplit = groupExpenseSplitsTable.insert(
                    groupExpenseSplitExpenseId <- groupExpenseId,
                    groupExpenseSplitUserId <- userId,
                    groupExpenseSplitAmount <- splitAmount
                )
                try db.run(insertSplit)
            }
        } catch {
            print("Error saving group expense: \(error)")  // Log errors
        }
    }
    
    
    func fetchUserId(for username: String) -> Int64? {
        do {
            // Query the database for the user with the given username
            let query = usersTable.filter(self.username == username)
            if let row = try db.pluck(query) {
                return row[userId]
            } else {
                print("No user found with username: \(username)")
                return nil
            }
        } catch {
            print("Error fetching userId for username \(username): \(error)")
            return nil
        }
    }
    
    // Fetch all group expenses for a given groupId
    func fetchExpenses(for groupId: Int64) -> [GroupExpense] {
        var expenses: [GroupExpense] = []
        
        do {
            // Query to fetch all expenses for the given groupId
            let expensesQuery = groupExpensesTable.filter(groupExpenseGroupId == groupId)
            
            // Loop through all expenses in the group
            for row in try db.prepare(expensesQuery) {
                let expenseId = row[groupExpenseId]
                let expenseDescription = row[groupExpenseDescription]
                let expenseAmount = row[groupExpenseAmount]
                let expensePayerId = row[groupExpensePayerId]
                
                // Fetch participants (usernames) for the current expense
                var participants: [String] = []
                let participantsQuery = groupExpenseSplitsTable.filter(groupExpenseSplitExpenseId == expenseId)
                
                for splitRow in try db.prepare(participantsQuery) {
                    let userId = splitRow[groupExpenseSplitUserId]
                    if let username = fetchUsername(for: userId) {
                        participants.append(username)
                    }
                }
                
                // Fetch split amounts for each participant in this expense
                var splitAmounts: [Int64: Double] = [:]
                for splitRow in try db.prepare(participantsQuery) {
                    let userId = splitRow[groupExpenseSplitUserId]
                    let splitAmount = splitRow[groupExpenseSplitAmount]
                    splitAmounts[userId] = splitAmount
                }
                
                // Create the GroupExpense object and add it to the expenses array
                let expense = GroupExpense(
                    id: expenseId,
                    description: expenseDescription,
                    amount: expenseAmount,
                    groupId: row[groupExpenseGroupId],
                    payerId: expensePayerId,
                    participants: participants,
                    splitAmounts: splitAmounts
                )
                expenses.append(expense)
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        return expenses
    }
    
    func fetchUsername(for userId: Int64) -> String? {
        do {
           
            
            // Query to fetch the username for the given userId
            let query = usersTable.filter(self.userId == userId)
            
            for row in try db.prepare(query) {
                return row[username]
            }
        } catch {
            print("Error fetching username: \(error)")
        }
        return nil
    }

       // Fetch all splits for a given groupId (across all expenses in the group)
       func fetchSplits(for groupId: Int64) -> [GroupExpenseSplit] {
           var splits: [GroupExpenseSplit] = []
           
           do {
               let expenses = fetchExpenses(for: groupId)  // Fetch expenses for the group
               for expense in expenses {
                   let splitsQuery = groupExpenseSplitsTable.filter(groupExpenseSplitExpenseId == expense.id)
                   for row in try db.prepare(splitsQuery) {
                       let split = GroupExpenseSplit(
                        splitid: row[groupExpenseSplitId],
                           expenseId: row[groupExpenseSplitExpenseId],
                           userId: row[groupExpenseSplitUserId],
                           amount: row[groupExpenseSplitAmount]
                       )
                       splits.append(split)
                   }
               }
           } catch {
               print("Error fetching splits: \(error)")
           }
           
           return splits
       }
//    func calculateBalance(for groupId: Int64, userId: Int64) -> Double {
//        let expenses = fetchExpenses(for: groupId)
//        let splits = fetchSplits(for: groupId)
//        
//        var totalOwedToUser = 0.0
//        
//        // Iterate through each expense in the group
//        for expense in expenses {
//            // Check if the logged-in user is the payer
//            if expense.payerId == userId {
//                let expenseSplits = splits.filter { $0.expenseId == expense.id }
//                // Sum up the split amounts for other users
//                for split in expenseSplits {
//                    if split.userId != userId {
//                        totalOwedToUser += split.amount
//                    }
//                }
//            }
//        }
//        
//        return totalOwedToUser
//    }
    
    func calculateBalance(for groupId: Int64, userId: Int64) -> Double {
        let expenses = fetchExpenses(for: groupId)
        let splits = fetchSplits(for: groupId)
        
        var totalOwed = 0.0
        var totalPaid = 0.0
        
        // Iterate through each expense in the group
        for expense in expenses {
            let expenseSplits = splits.filter { $0.expenseId == expense.id }
            
            // If the logged-in user is the payer
            if expense.payerId == userId {
                for split in expenseSplits {
                    if split.userId != userId {
                        totalOwed += split.amount // Others owe this amount to the user
                    }
                }
                totalPaid += expense.amount // The user paid this amount
            } else {
                // If another user is the payer
                for split in expenseSplits {
                    if split.userId == userId {
                        totalOwed += split.amount // User owes this amount to others
                    }
                }
            }
        }
        
        // Calculate the balance
        return totalPaid - totalOwed
    }

     // Utility function to fetch userId (assuming you're storing it in UserDefaults)
       func getLoggedInUserId() -> Int64 {
           return UserDefaults.standard.object(forKey: "loggedInUserId") as? Int64 ?? 0
       }
    func fetchSplits(forUserId userId: Int64) -> [ExpenseSplit] {
        var splits: [ExpenseSplit] = []
        
        do {
            // Query to fetch splits where the user is involved
            let query = expenseSplitsTable.filter(expenseSplitUserId == userId)
            
            for split in try db.prepare(query) {
                let splitId = split[expenseSplitsId]
                let expenseId = split[expenseSplitExpenseId]
                let amount = split[expenseSplitAmount]
                
                // Create an ExpenseSplit object and append it to the result
                let expenseSplit = ExpenseSplit(splitId: splitId, expenseId: expenseId, userId: userId, amount: amount)
                splits.append(expenseSplit)
            }
        } catch {
            print("Error fetching splits for user \(userId): \(error)")
        }
        
        return splits
    }
    
    func fetchSplits(forExpenseId expenseId: Int64) -> [ExpenseSplit] {
        var splits: [ExpenseSplit] = []

        do {
            // Query to fetch splits where the expenseId matches
            let query = expenseSplitsTable.filter(expenseSplitExpenseId == expenseId)

            // Loop through the query result
            for split in try db.prepare(query) {
                let splitId = split[expenseSplitsId]
                let userId = split[expenseSplitUserId]   // Fetch the user associated with the split
                let amount = split[expenseSplitAmount]   // Amount split for this user

                // Create an ExpenseSplit object and append it to the result
                let expenseSplit = ExpenseSplit(splitId: splitId, expenseId: expenseId, userId: userId, amount: amount)
                splits.append(expenseSplit)
            }
        } catch {
            print("Error fetching splits for expense \(expenseId): \(error)")
        }

        return splits
    }


}
