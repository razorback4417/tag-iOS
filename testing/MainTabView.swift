//
//  MainTabView.swift
//  testing
//
//  Created by Theo L on 7/13/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var showCreateView = false
    
    var body: some View {
        TabView {
            NavigationView {
                HomeView(showCreateView: $showCreateView)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Trips")
                .tabItem {
                    Image(systemName: "map")
                    Text("Trips")
                }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        .accentColor(Color(red: 0.25, green: 0.55, blue: 0.15))
        .fullScreenCover(isPresented: $showCreateView) {
            CreateView(isPresented: $showCreateView)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
