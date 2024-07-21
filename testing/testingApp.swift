//
//  testingApp.swift
//  testing
//
//  Created by Theo L on 6/27/24.
//

//import SwiftUI
//
//@main
//struct testingApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI
import Firebase

@main
struct TestingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


