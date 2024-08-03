//
//  testingApp.swift
//  testing
//
//  Created by Theo L on 6/27/24.
//

import SwiftUI
import Firebase

@main
struct testingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var tripViewModel = TripViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(tripViewModel)
        }
    }
}
