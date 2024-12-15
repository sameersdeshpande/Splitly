//
//  SplitlyApp.swift
//  Splitly
//
//  Created by Sameer Shashikant Deshpande on 11/27/24.
//

import SwiftUI

@main

struct SplitlyApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false // Store the dark mode preference
       
       init() {
        
           // Apply dark mode based on the setting
           if isDarkMode {
               // Set global dark mode
               UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
           } else {
               // Set global light mode
               UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
           }
       
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                                // Ensure the dark mode setting is applied on launch
                                if isDarkMode {
                                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                                } else {
                                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                                }
                            }
        }
    }
}
