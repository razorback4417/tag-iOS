//
//  SettingsView.swift
//  testing
//
//  Created by Theo L on 7/18/24.
//
import SwiftUI

struct SettingsView: View {
    @State private var showAccountInfo = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var showRideHistory = false
    @State private var showComingSoon = false
    
    @State private var showDeleteAccountAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.system(size: 25, weight: .heavy))
                        .padding(.top)
                    
                    SettingsSection(title: "General", items: [
                        SettingsItem(icon: "gearshape", title: "Account information", action: { showAccountInfo = true }),
                        SettingsItem(icon: "clock", title: "Ride History", action: { showRideHistory = true }),
                    ])
                    
                    SettingsSection(title: "Support", items: [
                        SettingsItem(icon: "exclamationmark.triangle", title: "Report an issue", action: { showComingSoon = true }),
                        SettingsItem(icon: "questionmark.circle", title: "FAQ", action: { showComingSoon = true }),
                    ])
                    
                    Spacer()
                    
                    Button(action: {
                        userViewModel.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Logout")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        showDeleteAccountAlert = true
                    }) {
                        Text("Delete Account")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
            }
            .background(Color.white)
            .alert(isPresented: $showDeleteAccountAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        userViewModel.deleteAccount { result in
                            switch result {
                            case .success:
                                presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                print("Error deleting account: \(error.localizedDescription)")
                                // You might want to show an error alert here
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showAccountInfo) {
                AccountInformationView()
                    .environmentObject(userViewModel)
            }
            .navigationDestination(isPresented: $showRideHistory) {
                RideHistoryView()
            }
            .navigationDestination(isPresented: $showComingSoon) {
                ComingSoonView()
            }
        }
    }
}


struct SettingsSection: View {
    let title: String
    let items: [SettingsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .heavy))
            
            ForEach(items) { item in
                Button(action: {
                    item.action?()
                }) {
                    HStack {
                        Image(systemName: item.icon)
                            .frame(width: 20, height: 20)
                        Text(item.title)
                            .font(.system(size: 15))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                }
                .padding(.vertical, 8)
            }
        }
    }
}



struct SettingsItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    var action: (() -> Void)? = nil
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
