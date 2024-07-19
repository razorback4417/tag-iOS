//
//  SettingsView.swift
//  testing
//
//  Created by Theo L on 7/18/24.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.system(size: 25, weight: .heavy))
                    .padding(.top)
                
                SettingsSection(title: "General", items: [
                    SettingsItem(icon: "gearshape", title: "Account information"),
                    SettingsItem(icon: "creditcard", title: "Payment methods"),
                    SettingsItem(icon: "clock", title: "Ride History"),
                    SettingsItem(icon: "person.2", title: "Friends")
                ])
                
                SettingsSection(title: "Support", items: [
                    SettingsItem(icon: "exclamationmark.triangle", title: "Report an issue"),
                    SettingsItem(icon: "questionmark.circle", title: "FAQ")
                ])
                
                Spacer()
                
                Button(action: {
                    // Handle logout action
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
            }
            .padding()
        }
        .background(Color.white)
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
                HStack {
                    Image(systemName: item.icon)
                        .frame(width: 20, height: 20)
                    Text(item.title)
                        .font(.system(size: 15))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
