import SwiftUI

struct GroupExpenseDetailView: View {
    @State private var groupExpenses: [GroupExpense] = []   
    @State private var description: String = ""              // Expense description
    @State private var amount: String = ""                   // Expense amount
    @State private var categoryId: Int64 = 0                 // Selected category ID
    @State private var payerId: Int64 = 0                    // Payer's user ID
    @State private var customSplitAmounts: [Int64: Double] = [:]  // Split amounts by user ID
    var participants: [String]
    @State private var categories: [(Int64, String)] = []    // Categories for Picker
    @State private var showSplitAmountSheet: Bool = false    // Whether to show the Split Amount Sheet
    @State private var groupName: String = ""
    @Binding var groupId: Int64? // Binding to the selected group's ID
    @State private var selectedParticipant: String? // Ensure it's mutable
         // Changed from String to Int64 for user ID
    @Environment(\.presentationMode) var presentationMode     // Dismiss the view after saving

    private var dbManager = DatabaseManager.shared

    init(groupId: Binding<Int64?>, participants: [String]) {
        // Initialize all properties
        self._groupId = groupId // Initializing the Binding
        self.participants = participants // Directly initializing participants
    }

    var body: some View {
        VStack(spacing: 20) {
            // Description input field
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
            
            // Amount input field with currency symbol
            VStack(alignment: .leading) {
                HStack {
                    Text("₹") // Currency symbol
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
            
            // Category selection
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "tag.fill") // Category icon
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Picker("Category", selection: $categoryId) {
                        ForEach(categories, id: \.0) { category in
                            Text(category.1)  // Category name
                                .tag(category.0)  // Bind the categoryId to the selection
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    .frame(height: 30)
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)
            
            // Payer selection
            VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "person.fill") // Icon for "Paid By"
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        Text("Paid By")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Picker("Select Participant", selection: $selectedParticipant) {
                        Text("Select a Participant")
                            .tag(nil as String?)  // Add a default "nil" tag for the "no selection" case
                        ForEach(participants, id: \.self) { participant in
                            Text(participant)
                                .tag(participant as String?)  // Use participant's name as tag
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    .frame(height: 30)
                    .onChange(of: selectedParticipant) { newValue in
                        print("Selected Participant: \(newValue ?? "None")")
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)
            
            // Button to open the Split Amount sheet
            Button(action: {
                showSplitAmountSheet.toggle()  // Show the Split Amount Sheet
            }) {
                Text("Split")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .frame(height: 40)
                    .cornerRadius(10)
            }
            .padding(.leading, 290)
            .padding(.top, 10)
            
            Button(action: {
                print("Add Expense Button Tapped")
                
                guard let totalAmount = Double(amount), totalAmount > 0 else {
                     print("Invalid amount")
                     return
                 }
                 
                 // Ensure that a participant has been selected
                 guard let selectedParticipantName = selectedParticipant else {
                     print("No participant selected")
                     return
                 }
                 
                 // Fetch the payerId from the selected participant's username using the DatabaseManager
                 if let payerId = DatabaseManager.shared.fetchUserId(for: selectedParticipantName) {
                     // Create the expense object with the correct payerId
                     let expense = GroupExpense(
                         id: 0,
                         description: description,
                         amount: totalAmount,
                         groupId: groupId ?? 0,
                         payerId: payerId,
                         participants: participants,
                         splitAmounts: customSplitAmounts
                     )
                    
                    print("Expense created: \(expense)") // Print expense object
                     
                    // Call saveGroupExpense
                    dbManager.saveGroupExpense(expense: expense)
                    
                    // Dismiss the view after saving
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Add Expense")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 150)
            
            Spacer()
        }
        
        .navigationBarTitle(groupName, displayMode: .inline) // Dynamically set the navigation title
        .onAppear {
            // Safely unwrap the groupId using optional binding
            if let unwrappedGroupId = groupId {
                self.groupName = dbManager.fetchGroupById(groupId: unwrappedGroupId) ?? "Unknown Group"
            } else {
                self.groupName = "Unknown Group"  // Fallback if groupId is nil
            }

            self.categories = dbManager.fetchCategories()
                
                    // Ensure that `selectedParticipant` is initialized with the first participant's name
                    if participants.count > 0 {
                        selectedParticipant = participants[0]
                    }
                
        }
        .sheet(isPresented: $showSplitAmountSheet) {
                // Convert participants into an array of tuples (id, name)
            let participantsWithIds = participants.map { participantName in
                 // Fetch userId from database for each participant's username
                 if let userId = dbManager.fetchUserId(for: participantName) {
                     return (id: userId, name: participantName)
                 } else {
                     // If userId is not found, return a default value (e.g., 0 or a placeholder name)
                     return (id: 0, name: participantName)
                 }
             }
                GroupSplitAmountView(participants: participantsWithIds, splitAmounts: $customSplitAmounts, onDismiss: {
                    self.showSplitAmountSheet = false
                })
            }
        }
    // Fetch the userId from the database for a given participant name


    }
struct GroupSplitAmountView: View {
    var participants: [(id: Int64, name: String)] // List of participants as tuples (userId, name)
    @Binding var splitAmounts: [Int64: Double]  // Split amounts for each participant, keyed by userId
    var onDismiss: () -> Void  // Dismiss the sheet
    
    var body: some View {
        VStack {
            Text("Custom Split Amount")
                .font(.headline)
                .padding()

            // Loop through each participant and allow them to enter their split amount
            ForEach(participants, id: \.id) { participant in
                HStack {
                    Text(participant.name)  // Display participant's name
                        .frame(width: 150, alignment: .leading)

                    // Allow editing of split amount
                    TextField("Amount", value: Binding(
                        get: {
                            self.splitAmounts[participant.id] ?? 0.0  // Default value if not set
                        },
                        set: { newValue in
                            self.splitAmounts[participant.id] = newValue
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
