//
//  testingApp.swift
//  testing
//
//  Created by Theo L on 6/27/24.
//

import SwiftUI
import Firebase
import GooglePlaces

@main
struct testingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var tripViewModel = TripViewModel()
    
    init() {
        GMSPlacesClient.provideAPIKey("AIzaSyBqaKYmm09G9FHCaQfjpsPnpRHEwQT9Ggo")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(tripViewModel)
        }
    }
}
