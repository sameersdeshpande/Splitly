import SwiftUI

struct GroupExpenseSummary: Identifiable {
    var id: Int64
    var groupName: String
    var amount: Double
    var participants: [String]
}

import SwiftUI

//struct GroupView: View {
//    @State private var groupExpenses: [GroupExpenseSummary] = [] // Will be populated with dynamic data
//    @State private var showCreateGroupModal: Bool = false // Show modal to create new group
//    @State private var selectedGroupId: Int64?  // Selected group ID (Optional)
//    
//    // Reference to the database manager
//    let databaseManager = DatabaseManager.shared
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack(spacing: 20) {
//                    // Group Expense Summaries
//                    ScrollView {
//                        VStack(spacing: 20) {
//                            ForEach(groupExpenses) { group in
//                                NavigationLink(
//                                    destination: ExpenseListView(
//                                        groupId: $selectedGroupId,  // Pass the group ID
//                                        participants: group.participants  // Pass the participants array
//                                    ),
//                                    tag: group.id,  // Tag to trigger navigation
//                                    selection: $selectedGroupId // Bind selection to trigger navigation
//                                ) {
//                                    VStack(alignment: .leading) {
//                                        Text(group.groupName)
//                                            .font(.headline)
//                                            .padding(.horizontal)
//                                            .padding(.top, 10)
//                                        
//                                        HStack {
//                                            Text("\(CurrencyManager.shared.selectedCurrencySymbol())\(String(format: "%.2f", group.amount))")
//                                                .font(.body)
//                                                .foregroundColor(group.amount >= 0 ? .green : .red)
//
//                                            
//                                            Spacer()
//                                        }
//                                        .padding(.horizontal)
//                                        
//                                        Text("Participants: \(group.participants.joined(separator: ", "))")
//                                            .font(.subheadline)
//                                            .padding(.horizontal)
//                                        
//                                        Divider()
//                                            .padding(.horizontal)
//                                    }
//                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
//                                    .padding(.horizontal)
//                                }
//                            }
//                        }
//                        .padding(.bottom, 10)
//                    }
//                    
//                    Spacer()
//                }
//
//                // Floating "+" Button to create new group
//                VStack {
//                    Spacer()  // Ensure this Spacer pushes the button towards the bottom
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            self.showCreateGroupModal.toggle()
//                        }) {
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 60, height: 60)
//                                .foregroundColor(.blue)
//                                .background(Circle().fill(Color.white))
//                        }
//                        .padding(.bottom, 40) // Bottom padding to give space from the bottom
//                        .padding(.trailing, 20) // Padding to the right
//                    }
//                }
//            }
//            .background(Color(UIColor.systemBackground))  // Ensure the background is visible
//            .sheet(isPresented: $showCreateGroupModal) {
//                CreateGroupView(groupExpenses: $groupExpenses)
//            }
//            .onAppear {
//                // Fetch group expenses and participants when the view appears
//                groupExpenses = databaseManager.fetchGroupExpenses()
//            }
//        }
//    }
//}

struct GroupView: View {
    @State private var groupExpenses: [GroupExpenseSummary] = [] // Will be populated with dynamic data
    @State private var showCreateGroupModal: Bool = false // Show modal to create new group
    @State private var selectedGroupId: Int64?  // Selected group ID (Optional)
    @State private var dragOffset = CGSize.zero  // Track the drag offset
        @State private var isMinimized = false
    // Reference to the database manager
    let databaseManager = DatabaseManager.shared

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    // Group Expense Summaries
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(groupExpenses) { group in
                                NavigationLink(
                                    destination: ExpenseListView(
                                        groupId: $selectedGroupId,  // Pass the group ID
                                        participants: group.participants  // Pass the participants array
                                    ),
                                    tag: group.id,  // Tag to trigger navigation
                                    selection: $selectedGroupId // Bind selection to trigger navigation
                                ) {
                                    VStack(alignment: .leading) {
                                        // Group Name
                                        Text(group.groupName)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .padding(.top, 10)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                        
                                        // Group Amount
                                        HStack {
//                                            Text("\(CurrencyManager.shared.selectedCurrencySymbol())\(String(format: "%.2f", group.amount))")
//                                                .font(.body)
//                                                .fontWeight(.semibold)
//                                                .foregroundColor(group.amount >= 0 ? .green : .red)

                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        
                                        // Participants list
                                        Text("Participants: \(group.participants.joined(separator: ", "))")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                        
                                   
                                            .padding(.horizontal)
                                    }
                                    .padding() // Adds internal padding to the cell
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                                            startPoint: .topLeading,  // Starting point of the gradient
                                            endPoint: .bottomTrailing  // Ending point of the gradient
                                        )
                                        .cornerRadius(20)  // Rounded corners
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)  // Shadow for better depth
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)  // Light border effect
                                        )
                                    )

                                                                   .padding(.horizontal) // Padding outside the cell
                                                                   .scaleEffect(selectedGroupId == group.id ? 1.05 : 1) // Interactive effect when selected
                                                                   .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedGroupId) // Interactive animation
                                                               }
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Spacer()
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.showCreateGroupModal.toggle()
                        }) {
                            Image(systemName: "plus.square.fill") // Icon for the button
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50) // Fixed size for the button
                                .foregroundColor(.white) // Icon color (white for good contrast)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing) // Gradient background
                                        .cornerRadius(50) // Rounded corners for a sleek look
                                )
                                
                                .padding() // Padding around the button
                        }
                        .padding(.bottom, 20) // Bottom padding to give space from the screen's bottom
                        
                    }
                }



                          }
            .background(Color(UIColor.systemBackground))  // Ensure the background is visible
            .sheet(isPresented: $showCreateGroupModal) {
                CreateGroupView(groupExpenses: $groupExpenses)
            }
            .onAppear {
                // Fetch group expenses and participants when the view appears
                groupExpenses = databaseManager.fetchGroupExpenses()
            }
        }
    }
}

struct CreateGroupView: View {
    @Binding var groupExpenses: [GroupExpenseSummary] // Binding to update the parent view
    @State private var groupName: String = ""
    @State private var groupAmount: String = ""
    @State private var selectedParticipants: Set<Int64> = [] // Set to track selected participant userIds
    @State private var nextId: Int // Tracks the next available ID for new groups
    @State private var allUsers: [User] = [] // All users fetched from the database

    private var databaseManager = DatabaseManager.shared  // Add reference to DatabaseManager

    init(groupExpenses: Binding<[GroupExpenseSummary]>) {
        _groupExpenses = groupExpenses
        _nextId = State(initialValue: groupExpenses.wrappedValue.count + 1) // Auto increment ID
    }

    var body: some View {
        VStack {
            Text("Create New Group")
                .font(.title)
                .padding()
            
            TextField("Group Name", text: $groupName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Amount (₹)", text: $groupAmount)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Select Participants")
                .font(.headline)
                .padding(.top)
            
            // List of users with checkboxes
            List(allUsers, id: \.userId) { user in
                HStack {
                    Text(user.username)
                    Spacer()
                    Image(systemName: selectedParticipants.contains(user.userId) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedParticipants.contains(user.userId) ? .blue : .gray)
                        .onTapGesture {
                            toggleParticipant(userId: user.userId)
                        }
                }
            }
            .frame(height: 200)
            
            Button(action: {
                print("Create Group button tapped")  // Debugging print
                if let amount = Double(groupAmount), !groupName.isEmpty, !selectedParticipants.isEmpty {
                    // Add new group to the database
                    do {
                        try databaseManager.createGroupWithMembers(groupName: groupName, amount: amount, userIds: Array(selectedParticipants))
                        
                        // Reset fields after saving
                        self.groupName = ""
                        self.groupAmount = ""
                        self.selectedParticipants.removeAll()
                    } catch {
                        print("Error creating group in database: \(error)")
                    }
                }
            }) {
                Text("Create Group")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .cornerRadius(20)
        .shadow(radius: 10)
        .onAppear {
            fetchUsersFromDB() // Fetch users from the database when the view appears
        }
    }

    private func toggleParticipant(userId: Int64) {
        if selectedParticipants.contains(userId) {
            selectedParticipants.remove(userId)
        } else {
            selectedParticipants.insert(userId)
        }
    }

    // Fetch users from the database
    private func fetchUsersFromDB() {
        // Fetch users from the DatabaseManager
        allUsers = databaseManager.fetchUsers()
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
