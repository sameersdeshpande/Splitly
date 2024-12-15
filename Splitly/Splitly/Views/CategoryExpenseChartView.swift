//import SwiftUI
//import UIKit
//
//struct CategoryExpenseChartView: View {
//    var expenses: [Expense]
//    var categories: [Int64: String]
//    
//    @State private var selectedCategory: String? = nil
//    @State private var hoverValue: String? = nil
//
//    // Calculate the total expenses per category
//    private var categoryTotals: [String: Double] {
//        var totals = [String: Double]()
//        
//        for expense in expenses {
//            if let categoryName = categories[expense.categoryId] {
//                totals[categoryName, default: 0] += expense.amount
//            }
//        }
//        
//        return totals
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Spending Analysis")
//                .font(.headline)
//                .padding(.top, 10)
//            
//            // Use GeometryReader to dynamically adjust the height of the bars
//            GeometryReader { geometry in
//                ScrollView(.horizontal) {
//                    HStack(spacing: 20) {
//                        ForEach(categoryTotals.keys.sorted(), id: \.self) { category in
//                            VStack {
//                                Rectangle()
//                                    .fill(self.color(forCategory: category))
//                                    .frame(width: 40, height: self.barHeight(forCategory: category, availableHeight: geometry.size.height))
//                                    .frame(maxHeight: .infinity, alignment: .bottom)
//                                    .onTapGesture {
//                                        selectedCategory = category
//                                    }
//                                    .onHover { isHovering in
//                                        hoverValue = isHovering ? "\(categoryTotals[category] ?? 0)" : nil
//                                    }
//
//                                Text(category)
//                                    .font(.caption)
//                                    .frame(width: 60, alignment: .center)
//                                    .lineLimit(1)
//                                    .truncationMode(.tail)
//                            }
//                            .frame(maxHeight: .infinity)
//                        }
//                    }
//                    .padding(.top, 10)
//                }
//            }
//            .frame(height: 200)
//
//            if let hoverValue = hoverValue {
//                Text("Value: ₹\(hoverValue)")
//                    .font(.subheadline)
//                    .padding(.top, 10)
//                    .foregroundColor(.gray)
//            } else if let selectedCategory = selectedCategory {
//                Text("Spent on \(selectedCategory): ₹\(Int(categoryTotals[selectedCategory] ?? 0))")
//                    .font(.subheadline)
//                    .padding(.top, 10)
//                    .foregroundColor(.gray)
//            }
//
//            // Generate PDF Button
//            Button(action: {
//                if let pdfURL = self.generatePDF() {
//                    // Assuming `viewController` is your current view controller (can be obtained in SwiftUI with a `UIViewControllerRepresentable`)
//                    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
//                        self.presentPDFActivity(pdfURL: pdfURL, in: rootVC)
//                    }
//                }
//            }) {
//                Text("Export file")
//                  
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 20)
//        }
//        .padding(.leading, 15)
//        .padding(.trailing, 15)
//    }
//
//    // Function to assign colors based on category
//    private func color(forCategory category: String) -> Color {
//        switch category {
//        case "Food": return .red
//        case "Transport": return .blue
//        case "Entertainment": return .green
//        case "Shopping": return .yellow
//        case "Bills": return .mint
//        default: return .orange
//        }
//    }
//
//    private func barHeight(forCategory category: String, availableHeight: CGFloat) -> CGFloat {
//        let maxExpense = categoryTotals.values.max() ?? 1
//        let scale = availableHeight * 0.8
//        let height = CGFloat(categoryTotals[category] ?? 0) / maxExpense * scale
//        return height
//    }
//
//    func generatePDF() -> URL? {
//           // Create a PDF renderer context
//           let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))  // A4 paper size
//           
//           // Start a new PDF context and begin a page
//           let data = pdfRenderer.pdfData { (context) in
//               context.beginPage()
//               
//               // 1. Draw the logo at the top
//               if let logoImage = UIImage(named: "logo") {  // Ensure logo image is in your assets
//                   let logoSize = CGSize(width: 100, height: 100)
//                   let logoRect = CGRect(x: 50, y: 20, width: logoSize.width, height: logoSize.height)
//                   logoImage.draw(in: logoRect)
//               }
//               
//               // Update the yPosition after the logo is drawn
//               var yPosition: CGFloat = 140  // Adjust this based on your logo's size
//               
//               // 2. Draw the "Expenses" title
//               let titleAttributes: [NSAttributedString.Key: Any] = [
//                   .font: UIFont.boldSystemFont(ofSize: 18),
//                   .foregroundColor: UIColor.black
//               ]
//               let titleString = "Expenses"
//               let titleNSString = NSString(string: titleString)
//               titleNSString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)
//               
//               // 3. List all the expenses made by the user
//               yPosition += 30  // Add extra space for the title
//               for expense in expenses {
//                   let text = "\(expense.description): ₹\(expense.amount)"
//                   let attributes: [NSAttributedString.Key: Any] = [
//                       .font: UIFont.systemFont(ofSize: 14)
//                   ]
//                   let expenseString = NSString(string: text)
//                   expenseString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: attributes)
//                   yPosition += 20
//               }
//               
//               // 4. Draw the "Category Breakdown" title
//               let breakdownTitle = "Category Breakdown"
//               let breakdownTitleNSString = NSString(string: breakdownTitle)
//               breakdownTitleNSString.draw(at: CGPoint(x: 50, y: yPosition + 20), withAttributes: titleAttributes)
//               yPosition += 40
//               
//               // 5. List all categories and their totals
//               for category in categoryTotals.keys.sorted() {
//                   let expense = categoryTotals[category] ?? 0
//                   let text = "\(category): ₹\(expense)"
//                   let attributes: [NSAttributedString.Key: Any] = [
//                       .font: UIFont.systemFont(ofSize: 14)
//                   ]
//                   let categoryString = NSString(string: text)
//                   categoryString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: attributes)
//                   yPosition += 20
//               }
//           }
//           
//           // Save the generated PDF to a file URL
//           let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Expenses_Report.pdf")
//           try? data.write(to: fileURL)
//           
//           return fileURL
//       }
//    // Generate a snapshot of the chart view to render as PDF
//    func chartView() -> UIView {
//        let hostingController = UIHostingController(rootView: self)
//        hostingController.view.frame = CGRect(x: 0, y: 0, width: 495, height: 300)  // Adjust size for the chart
//        return hostingController.view
//    }
//
//    // Function to present the PDF using UIActivityViewController (for sharing or saving)
//    func presentPDFActivity(pdfURL: URL, in viewController: UIViewController) {
//        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
//        viewController.present(activityViewController, animated: true, completion: nil)
//    }
//}

import SwiftUI
import UIKit

struct CategoryExpenseChartView: View {
    var expenses: [Expense]
    var categories: [Int64: String]
    
    @State private var selectedCategory: String? = nil
    @State private var hoverValue: String? = nil
    @State private var userPayerCount: Int = 0
       @State private var otherPayerCount: Int = 0
    var currentUserId: Int64 {
        return UserDefaults.standard.object(forKey: "loggedInUserId") as? Int64 ?? 0  // Default to 0 if not found
    }
    // Calculate the total expenses per category
    private var categoryTotals: [String: Double] {
        var totals = [String: Double]()
        
        for expense in expenses {
            if let categoryName = categories[expense.categoryId] {
                totals[categoryName, default: 0] += expense.amount
            }
        }
        
        return totals
    }
    private func updatePayerCounts() {
        let db = DatabaseManager.shared  // Assuming DataManager is a singleton
        
        let allexpense = db.fetchExpenses()

        // Reset counts before recalculating
        userPayerCount = 0
        otherPayerCount = 0

        // Count the number of times the current user and others are the payer
        for expense in allexpense {
            if expense.payerId == currentUserId {
                userPayerCount += 1
            } else {
                otherPayerCount += 1
            }
        }    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title for the chart
            Text("Spending Analysis")
                .font(.headline)
                .foregroundColor(.white) // White text color
                .padding(.vertical, 10) // Vertical padding inside the capsule
                .padding(.horizontal, 20) // Horizontal padding inside the capsule
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(radius: 5) // Add a slight shadow for depth
                .onAppear {
                           updatePayerCounts()  // Trigger the function when the view appears
                       }


            // Card-like view for the chart with a shadow and rounded corners
            VStack {
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(categoryTotals.keys.sorted(), id: \.self) { category in
                                VStack {
                                    Rectangle()
                                        .fill(self.color(forCategory: category))
                                        .frame(width: 40, height: self.barHeight(forCategory: category, availableHeight: geometry.size.height))
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                        .onTapGesture {
                                            selectedCategory = category
                                        }
                                        .onHover { isHovering in
                                            hoverValue = isHovering ? "\(categoryTotals[category] ?? 0)" : nil
                                        }

                                    Text(category)
                                        .font(.caption)
                                        .frame(width: 60, alignment: .center)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .background(Color(UIColor.systemBackground))
                                }
                                .frame(maxHeight: .infinity)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                .frame(height: 200)
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.bottom, 15)

            // Display selected category or hover value
            if let hoverValue = hoverValue {
                Text("Value: ₹\(hoverValue)")
                    .font(.subheadline)
                    .padding(.top, 10)
                    .foregroundColor(.gray)
            } else if let selectedCategory = selectedCategory {
                Text("Spent on \(selectedCategory): ₹\(Int(categoryTotals[selectedCategory] ?? 0))")
                    .font(.subheadline)
                    .padding(.top, 10)
                    .foregroundColor(.gray)
            }
            DonutChart(userPayerCount: userPayerCount, otherPayerCount: otherPayerCount)
                           .padding(.bottom,05)
            // Export PDF Button
            Button(action: {
                if let pdfURL = self.generatePDF() {
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                        self.presentPDFActivity(pdfURL: pdfURL, in: rootVC)
                    }
                }
            }) {
                Text("Export Report")
                    .fontWeight(.bold)
                    .foregroundColor(.white) // White text color
                    .padding()
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.blue]), // Gradient from green to blue
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(radius: 5) // Add a slight shadow for depth
                    .frame(alignment: .center)
            }
            .padding(.top, 20)
            .frame(alignment: .center)
        }
        .padding([.leading, .trailing], 15)
    }

    // Function to assign colors based on category
    private func color(forCategory category: String) -> Color {
        switch category {
        case "Food": return .red
        case "Transport": return .blue
        case "Entertainment": return .green
        case "Shopping": return .yellow
        case "Bills": return .mint
        default: return .orange
        }
    }

    private func barHeight(forCategory category: String, availableHeight: CGFloat) -> CGFloat {
        let maxExpense = categoryTotals.values.max() ?? 1
        let scale = availableHeight * 0.8
        let height = CGFloat(categoryTotals[category] ?? 0) / maxExpense * scale
        return height
    }

    // Generate a PDF report for the expenses and category breakdown
    func generatePDF() -> URL? {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))  // A4 size

        let data = pdfRenderer.pdfData { (context) in
            context.beginPage()

            // Draw the logo
            if let logoImage = UIImage(named: "logo") {
                let logoSize = CGSize(width: 100, height: 100)
                let logoRect = CGRect(x: 50, y: 20, width: logoSize.width, height: logoSize.height)
                logoImage.draw(in: logoRect)
            }

            var yPosition: CGFloat = 140

            // Draw title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            let titleNSString = NSString(string: "Expenses Report")
            titleNSString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)

            yPosition += 30

            // List of expenses
            for expense in expenses {
                let text = "\(expense.description): ₹\(expense.amount)"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14)
                ]
                let expenseNSString = NSString(string: text)
                expenseNSString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: attributes)
                yPosition += 20
            }

            // Category Breakdown Title
            let breakdownTitleNSString = NSString(string: "Category Breakdown")
            breakdownTitleNSString.draw(at: CGPoint(x: 50, y: yPosition + 20), withAttributes: titleAttributes)
            yPosition += 40

            // Category totals
            for category in categoryTotals.keys.sorted() {
                let expense = categoryTotals[category] ?? 0
                let text = "\(category): ₹\(expense)"
                let categoryNSString = NSString(string: text)
                categoryNSString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)
                yPosition += 20
            }
            let payerCountText = "User Payer Count: \(userPayerCount), Other Payer Count: \(otherPayerCount)"
                      let payerCountNSString = NSString(string: payerCountText)
                      payerCountNSString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)
                  
        }

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Expenses_Report.pdf")
        try? data.write(to: fileURL)
        return fileURL
    }

    // Function to present PDF for sharing
    func presentPDFActivity(pdfURL: URL, in viewController: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
