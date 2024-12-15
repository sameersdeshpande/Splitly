# Splitly - A Simple Expense Splitter App

**Splitly** is a simple, user-friendly iOS app built with **SwiftUI** and **SQLite** that helps you easily split bills and track shared expenses with friends, family, or colleagues. Whether you're at a restaurant, on a trip, or just sharing any group expense, Splitty ensures everyone knows exactly how much they owe.

---

## Features

- **Split Expenses**: Add items to a group bill and split the total cost among multiple participants.
- **Multiple Participants**: Add as many participants as needed and track individual amounts.
- **Customizable Splits**: Split the costs equally or adjust individual contributions.
- **Real-time Updates**: The app dynamically updates the total and individual balances as you add, remove, or adjust expenses.
- **Currency Support**: Choose from different currencies for international usage.
- **Currency Conversion**: Automatically convert expenses into different currencies based on real-time exchange rates, making it easy to split bills across borders.
- **Charts & Data Visualization**: View detailed charts that provide insights into your spending patterns. The app includes pie charts, and bar graphs to help visualize expenses and track trends over time.
- **Simple and Intuitive UI**: Clean, modern design with a straightforward user interface that makes splitting bills easy.
- **Dark Mode Support**: The app supports both light and dark mode for a seamless user experience in different lighting conditions.

---

## Screenshots

Here’s a preview of what Splitty looks like:

<img src="screenshot.png" alt="Screenshot" width="800" height="400"/>



---


We used the following technologies to build **Splitty**:

![Swift](https://img.shields.io/badge/Swift-4C4C4C?style=flat&logo=swift&logoColor=white)  
![Xcode](https://img.shields.io/badge/Xcode-1575F9?style=flat&logo=xcode&logoColor=white)  
![SwiftUI](https://img.shields.io/badge/SwiftUI-100000?style=flat&logo=swift&logoColor=white)  
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)  
![SQLite.swift](https://img.shields.io/badge/SQLite.swift-3C3C3C?style=flat&logo=swift&logoColor=gray)  
![UIKit](https://img.shields.io/badge/UIKit-0078D4?style=flat&logo=apple&logoColor=red)
![Charts](https://img.shields.io/badge/Charts-4C4C4C?style=flat&logo=chartjs&logoColor=white)  




---

## Installation

To get started with **Splitty**, follow these steps:

### 1. Clone the repository

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/yourusername/splitty.git
```

### 2. Open the project in Xcode

After cloning the repo, navigate to the project folder and open the .xcworkspace file (not the .xcodeproj file) in Xcode. This ensures that all dependencies and configurations are properly set up.

```bash
cd splitty
open Splitty.xcworkspace
```

### 3. Build and Run

Once the project is open in Xcode, select a device or simulator from the toolbar.
Press Cmd + R to build and run the app.
Ensure that you have the latest version of Xcode installed for compatibility.
The app should launch on the selected simulator or physical device.

## Future Scope

Although **Splitty** is fully functional, there are several areas where future improvements can be made:

1. **Cloud Sync Support**:  
   Enable cloud-based syncing so users can access their expenses across multiple devices. This could be done using Firebase, CloudKit, or another cloud storage solution.

2. **User Authentication**:  
   Allow users to sign in and track their expenses across different sessions. You can integrate Firebase Authentication or Apple's Sign in with Apple to offer seamless login.

3. **Notifications**:  
   Send notifications to participants when a bill is added, updated, or when they have pending amounts to pay. This can be done using Push Notifications or Local Notifications.

4. **Improved UI/UX**:  
   Although the current UI is simple and functional, there’s always room for improvement. You can add more intuitive animations, gestures, and more polished designs for a better user experience.

5. **Enhanced Data Analytics**:  
   The app already includes analytics that track spending patterns and generates charts. However, future enhancements could provide deeper insights such as "category-wise spending breakdown" or "spending trends over time". You could also allow users to export reports and view their spending in different visualizations like pie charts, bar graphs, or line charts.

6. **Real-Time Payment Settlement & Integration**:  
   Implement integration with popular payment services (like PayPal, Stripe, or Apple Pay) to allow participants to settle their dues directly from the app. This would enable real-time transactions, making the bill-splitting experience seamless.

7. **Customizable Themes**:  
   Implement more customizable themes, allowing users to adjust the app's appearance beyond dark/light mode (e.g., color schemes, fonts).

---


## Contributing

We welcome contributions to **Splitty**! If you'd like to improve the app, fix bugs, or add new features, please feel free to fork the repository and submit a pull request.

### How to Contribute

1. **Fork the repository**:  
   Click on the **Fork** button at the top right of the project page to create your own copy of the repository.

2. **Create a new branch**:  
   Create a new branch for your changes. It’s best to create a branch with a descriptive name related to the feature or bug you're working on (e.g., `feature/add-notifications` or `fix/bug-123`).

3. **Make the necessary changes**:  
   Work on your changes in the new branch. Make sure your code follows the app’s coding style and conventions.

4. **Commit your changes**:  
   Commit your changes with descriptive commit messages. It helps to reference the issue or feature you're addressing.  
   Example:  
   ```bash
   git commit -m "Improve spending analytics visualization"
   ```
5. Push to your forked repository:
Push the changes to your forked repository.

6. Create a Pull Request:
Once your changes are ready, create a pull request to the main branch of the original repository.
Include a clear description of what changes you’ve made and why. If applicable, reference the related issue number (e.g., "Closes #45").


### Code of Conduct

Please adhere to our code of conduct while contributing to ensure a welcoming and inclusive environment for all. We strive to maintain a friendly and respectful community.
Added a legal note under the **License** section that clarifies the project is for academic purposes and all rights are reserved. It also makes clear that no plagiarism is encouraged or allowed, and the project is open for reference and contributions.

