//
//  ContentView.swift
//  testing
//
//  Created by Theo L on 6/27/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        Group {
            if userViewModel.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            userViewModel.checkUserStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserViewModel())
    }
}

