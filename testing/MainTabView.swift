//
//  MainTabView.swift
//  testing
//
//  Created by Theo L on 7/13/24.
//

import SwiftUI

//struct MainTabView: View {
//    @State private var showCreateView = false
//    @State private var navigateToMyTrips = false
//    
//    var body: some View {
//        TabView {
//            NavigationView {
//                HomeView(showCreateView: $showCreateView)
//            }
//            .tabItem {
//                Image(systemName: "house")
//                Text("Home")
//            }
//            
//            SearchView()
//            .tabItem {
//                    Image(systemName: "map")
//                    Text("Trips")
//                }
//            
//            NavigationView {
//                SettingsView()
//            }
//            .tabItem {
//                Image(systemName: "gear")
//                Text("Settings")
//            }
//        }
//        .accentColor(Color(red: 0.25, green: 0.55, blue: 0.15))
//        .fullScreenCover(isPresented: $showCreateView) {
//            CreateView(isPresented: $showCreateView)
//        }
//    }
//}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @State private var showCreateView = false
    @State private var selectedTab = 0
    @State private var navigateToMyTrips = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView(showCreateView: $showCreateView)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)
            
            NavigationView {
                SearchView()
                    .navigationDestination(isPresented: $navigateToMyTrips) {
                        MyTripsView()
                    }
            }
            .tabItem {
                Image(systemName: "map")
                Text("Trips")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(2)
        }
        .accentColor(Color(red: 0.25, green: 0.55, blue: 0.15))
        .fullScreenCover(isPresented: $showCreateView) {
            CreateView(isPresented: $showCreateView, onViewMyTrip: {
                showCreateView = false
                selectedTab = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigateToMyTrips = true
                }
            })
        }
    }
}
