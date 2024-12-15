//import SwiftUI
//
//struct UserPage: View {
//    var username: String
//    @State private var selectedTab = 0
//    @State private var displayPhoto: String?
//    @StateObject private var userViewModel = UserViewModel()
//    @State private var navigateToSettings = false
//    @Environment(\.presentationMode) var presentationMode
//    var body: some View {
//        NavigationStack { // Wrap everything in a NavigationStack
//            VStack {
//                HStack {
//                    Image("logo2")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 110, height: 110)
//                        .padding(.leading, 0)
//                    Spacer()
//                    HStack {
//                        if let photo = displayPhoto, !photo.isEmpty {
//                            Image(photo)
//                                .resizable()
//                                .scaledToFill()
//                                .clipShape(Circle())
//                                .frame(width: 50, height: 50)
//                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                        } else {
//                            Image(systemName: "person.crop.circle") // Default user icon
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.blue)
//                                .clipShape(Circle())
//                                .frame(width: 40, height: 50)
//                        }
//                    }
//                    .padding(.trailing, 10)
//                }
//                .padding(.horizontal, 2)
//                .frame(height: 30)
//                
//            
//                TabView {
//                    // Home Tab
//                    HomeView()
//                        .tabItem {
//                            Image(systemName: "house.fill")
//                            Text("Home")
//                        }
//                        .tag(1)
//                    GroupView()
//                        .tabItem {
//                            Image(systemName: "person.2.fill")
//                            Text("Group")
//                        }
//                        .tag(2)
//                    
//                    AddExpenseView()
//                        .tabItem {
//                            Image(systemName: "plus.circle.fill")
//                                .font(.system(size: 60))
//                                .foregroundColor(.white)
//                                .padding(20)
//                                .background(Circle().fill(Color.blue))
//                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
//                            Text("Add")
//                                .fontWeight(.bold)
//                        }
//                        .tag(3)
//                    
//                    ActivityView()
//                        .tabItem {
//                            Image(systemName: "flame.fill")
//                            Text("Activity")
//                        }
//                        .tag(4)
//                    
//                    SettingsView()
//                        .tabItem {
//                            Image(systemName: "gearshape.fill")
//                            Text("Settings")
//                        }
//                        .tag(5) // Tag for Settings Tab
//                }
//                
//                .accentColor(.blue) // Set the accent color for the selected tab item
//                /*.frame(height: 60)*/ // Set the height of the TabView
//            }
//            .onAppear {
//                if let user = userViewModel.fetchUserByUsername(username: username) {
//                    self.displayPhoto = user.displayPhoto
//                }
//            }
//         
//            .background(Color(UIColor.systemBackground))
////            .edgesIgnoringSafeArea(.top)
//            
//            .navigationBarBackButtonHidden(true)  // Hide the default back button
//      
//        }//close navistack
//    }
//}
//
//struct UserPage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPage(username: "JohnDoe")
//    }
//}
//import SwiftUI
//
//struct UserPage: View {
//    var username: String
//    @State private var selectedTab = 0
//    @State private var displayPhoto: String?
//    @StateObject private var userViewModel = UserViewModel()
//    
//    var body: some View {
//        NavigationStack { // Wrap everything in a NavigationStack
//            VStack {
//                // Header Section
//                HStack {
//                    Image("logo2")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 110, height: 110)
//                        .padding(.leading, 0)
//                    Spacer()
//                    HStack {
//                        if let photo = displayPhoto, !photo.isEmpty {
//                            Image(photo)
//                                .resizable()
//                                .scaledToFill()
//                                .clipShape(Circle())
//                                .frame(width: 50, height: 50)
//                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                        } else {
//                            Image(systemName: "person.crop.circle") // Default user icon
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.blue)
//                                .clipShape(Circle())
//                                .frame(width: 40, height: 50)
//                        }
//                    }
//                    .padding(.trailing, 10)
//                }
//                .padding(.horizontal, 2)
//                .frame(height: 30)
//
//                // Main Content Area
//                VStack {
//                    if selectedTab == 1 {
//                        HomeView()
//                    } else if selectedTab == 2 {
//                        GroupView()
//                    } else if selectedTab == 3 {
//                        AddExpenseView()
//                    } else if selectedTab == 4 {
//                        ActivityView()
//                    } else if selectedTab == 5 {
//                        SettingsView()
//                    }
//
//                    Spacer() // Push the content up, so tab bar stays at the bottom
//                }
//
//                // Custom Tab Bar stays fixed at the bottom
//                CustomTabBar(selectedTab: $selectedTab)
//                    .frame(height: 70)
//                    .padding(.bottom, 0) // No extra padding to shift it up
//            }
//            .onAppear {
//                if let user = userViewModel.fetchUserByUsername(username: username) {
//                    self.displayPhoto = user.displayPhoto
//                }
//            }
//            .navigationBarBackButtonHidden(true)  // Hide the default back button
//        }
//    }
//}
//
//struct CustomTabBar: View {
//    @Binding var selectedTab: Int
//    
//    var body: some View {
//        HStack {
//            TabBarItem(image: "house.fill", title: "Home", tag: 1, selectedTab: $selectedTab)
//            TabBarItem(image: "person.2.fill", title: "Group", tag: 2, selectedTab: $selectedTab)
//            TabBarItem(image: "plus.circle.fill", title: "Add", tag: 3, selectedTab: $selectedTab, isAddButton: true)
//            TabBarItem(image: "flame.fill", title: "Activity", tag: 4, selectedTab: $selectedTab)
//            TabBarItem(image: "gearshape.fill", title: "Settings", tag: 5, selectedTab: $selectedTab)
//        }
//        .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)) // Gradient background
//        .clipShape(Capsule()) // Capsule-shaped tab bar
//        .shadow(radius: 10) // Add shadow for depth
//        .padding(.bottom, 0) // Ensure no extra bottom padding
//        .padding(.horizontal, 15) // Add horizontal padding for spacing
//    }
//}
//
//struct TabBarItem: View {
//    var image: String
//    var title: String
//    var tag: Int
//    @Binding var selectedTab: Int
//    var isAddButton: Bool = false
//    
//    @State private var isPressed = false
//
//    var body: some View {
//        VStack {
//            if isAddButton {
//                // Special Add Button with a higher, curved background
//                Button(action: {
//                    withAnimation {
//                        selectedTab = tag
//                    }
//                }) {
//                    Image(systemName: image)
//                        .font(.system(size: 60))
//                        .foregroundColor(selectedTab == tag ? .white : .gray) // White when selected, gray when not
//                        .padding(20) // Larger padding for the Add button
//                        .background(
//                            Capsule()
//                                .fill(selectedTab == tag ? Color.purple.opacity(0.2) : Color.clear) // Elevated background with subtle purple
//                        )
//                        .offset(y: -10) // Slightly elevate the Add button
//                        .scaleEffect(isPressed ? 1.1 : 1.0) // Add scale effect on press
//                        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0), value: isPressed) // Press animation
//                }
//                .padding(.top, 5) // Elevate the "Add" button a little bit
//            } else {
//                // Regular Tab Item with same background color for each tab
//                Button(action: {
//                    withAnimation {
//                        selectedTab = tag
//                    }
//                }) {
//                    VStack {
//                        ZStack {
//                            // Background for the selected tab
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(selectedTab == tag ? Color.purple.opacity(0.2) : Color.clear) // Purple highlight for selected tab
//                                .frame(height: 50) // Standard height for regular tabs
//                                .padding(.horizontal, 10) // Padding to give the background a bit of space
//
//                            // Tab Icon and Text
//                            VStack {
//                                Image(systemName: image)
//                                    .font(.system(size: 24))
//                                    .foregroundColor(selectedTab == tag ? .white : .gray)
//
//                                Text(title)
//                                    .font(.caption)
//                                    .foregroundColor(selectedTab == tag ? .white : .gray)
//                            }
//                            .padding(.top, 5) // Padding to center the text and icon
//                        }
//                        .scaleEffect(isPressed ? 1.1 : 1.0) // Scale effect on click
//                        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0), value: isPressed) // Button press animation
//                    }
//                }
//                .simultaneousGesture(LongPressGesture().onChanged { _ in
//                    isPressed = true
//                }.onEnded { _ in
//                    isPressed = false
//                }) // Long press gesture for scale effect
//            }
//        }
//        .frame(maxWidth: .infinity) // Distribute buttons evenly
//    }
//}
//
//struct UserPage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPage(username: "JohnDoe")
//    }
//}
import SwiftUI

struct UserPage: View {
    var username: String
    @State private var selectedTab = 0
    @State private var displayPhoto: String?
    @StateObject private var userViewModel = UserViewModel()
    @Binding var isLoggedIn: Bool
    var body: some View {
        NavigationStack { // Wrap everything in a NavigationStack
            VStack {
                // Header Section
                HStack {
                    Text("Splitly")
                        .font(.custom("BebasNeue", size: 30))
  // Bold Times New Roman
                        .foregroundColor(.white)  // White text color
                        .padding(.leading, 0)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 20)  // Add horizontal padding for better spacing
                         // Slight slant (rotation)
                        .shadow(color: .white.opacity(0.1), radius: 1, x: 3, y: 3)  // Subtle metallic shine with offset
                        .shadow(color: .white.opacity(0.2), radius: 5, x: -3, y: -3)  // Slight glow but not too overpowering


                    Spacer()
                    HStack {
                        if let photo = displayPhoto, !photo.isEmpty {
                            Image(photo)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Image(systemName: "person.crop.circle") // Default user icon
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .frame(width: 40, height: 50)
                                .padding(.bottom, 40)
                        }
                    }
                    .padding(.trailing, 10)
                }
                .padding(.horizontal, 2)
                .frame(height: 20)
                .padding(.top, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                        startPoint: .topLeading,  // Starting point of the gradient
                        endPoint: .bottomTrailing  // Ending point of the gradient
                    )
                )


                // Main Content Area
                VStack {
                    if selectedTab == 1 {
                        HomeView()
                    } else if selectedTab == 2 {
                        GroupView()
                    } else if selectedTab == 3 {
                        AddExpenseView()
                    } else if selectedTab == 4 {
                        ActivityView()
                    } else if selectedTab == 5 {
                        //SettingsView()
                        SettingsView(isLoggedIn: $isLoggedIn)
                    }

                    Spacer() // Push the content up, so tab bar stays at the bottom
                }

                // Custom Tab Bar stays fixed at the bottom
                CustomTabBar(selectedTab: $selectedTab)
                    .frame(height: 70)
                    .padding(.bottom, 0) // No extra padding to shift it up
            }
            .onAppear {
                if let user = userViewModel.fetchUserByUsername(username: username) {
                    self.displayPhoto = user.displayPhoto
                }
            }
            .navigationBarBackButtonHidden(true)  // Hide the default back button
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true) 
        }
        .navigationBarBackButtonHidden(true)  // Hide the default back button
        
    }
        
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarItem(image: "house.fill", title: "Home", tag: 1, selectedTab: $selectedTab)
            TabBarItem(image: "person.2.fill", title: "Group", tag: 2, selectedTab: $selectedTab)
            TabBarItem(image: "plus.circle.fill", title: "Add", tag: 3, selectedTab: $selectedTab, isAddButton: true)
            TabBarItem(image: "flame.fill", title: "Activity", tag: 4, selectedTab: $selectedTab)
            TabBarItem(image: "gearshape.fill", title: "Settings", tag: 5, selectedTab: $selectedTab)
        }
        .background(
               LinearGradient(
                   gradient: Gradient(colors: [Color.blue, Color.purple]),  // Gradient from blue to purple
                   startPoint: .topLeading,  // Starting point of the gradient
                   endPoint: .bottomTrailing // Ending point of the gradient
               )
           )

        .clipShape(Capsule()) // Capsule-shaped tab bar
        .shadow(radius: 10) // Add shadow for depth
        .padding(.bottom, 0) // Ensure no extra bottom padding
        .padding(.horizontal, 15) // Add horizontal padding for spacing
    }
}

struct TabBarItem: View {
    var image: String
    var title: String
    var tag: Int
    @Binding var selectedTab: Int
    var isAddButton: Bool = false
    
    @State private var isPressed = false

    var body: some View {
        VStack {
            if isAddButton {
                // Special Add Button with a height of 60
                Button(action: {
                    withAnimation {
                        selectedTab = tag
                    }
                }) {
                    Image(systemName: image)
                        .font(.system(size: 60))
                        .foregroundColor(selectedTab == tag ? .white : .white) // White when selected, gray when not
                        .padding(20) // Larger padding for the Add button
                        .background(
                            Capsule()
                                .fill(selectedTab == tag ? Color.purple.opacity(0.6) : Color.clear) // Elevated background with subtle purple
                        )
                        .offset(y: -4
                        ) // Slightly elevate the Add button
                        .scaleEffect(isPressed ? 1.1 : 1.0) // Add scale effect on press
                        .animation(.spring(response: 0.2, dampingFraction: 1.5, blendDuration: 0), value: isPressed) // Press animation
                }
                .padding(.top, 5) // Elevate the "Add" button a little bit
                .frame(height: 80) // Ensure height of Add button is 60
            } else {
                // Regular Tab Item with a height of 40 for other icons
                Button(action: {
                    withAnimation {
                        selectedTab = tag
                    }
                }) {
                    VStack {
                        ZStack {
                            // Background for the selected tab
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTab == tag ? Color.blue.opacity(0.2) : Color.clear) // Purple highlight for selected tab
                                .frame(height: 80) // Height set to 40 for regular tabs
                                .padding(.horizontal, 30) // Padding to give the background a bit of space

                            // Tab Icon and Text
                            VStack {
                                Image(systemName: image)
                                    .font(.system(size: 24))
                                    .foregroundColor(selectedTab == tag ? .white : .white)

                                Text(title)
                                    .font(.caption)
                                    .foregroundColor(selectedTab == tag ? .white : .white)
                            }
                            .padding(.top, 5) // Padding to center the text and icon
                        }
                        .scaleEffect(isPressed ? 1.1 : 1.0) // Scale effect on click
                        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.9), value: isPressed) // Button press animation
                    }
                }
                .simultaneousGesture(LongPressGesture().onChanged { _ in
                    isPressed = true
                }.onEnded { _ in
                    isPressed = false
                }) // Long press gesture for scale effect
                .frame(height: 40) // Ensure height of regular buttons is 40
            }
        }
        .frame(maxWidth: .infinity) // Distribute buttons evenly
    }
}

//struct UserPage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPage(username: "JohnDoe", isLoggedIn: $isLoggedIn)
//    }
//}
