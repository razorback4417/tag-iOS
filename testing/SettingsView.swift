//
//  SettingsView.swift
//  testing
//
//  Created by Theo L on 7/18/24.
//
import SwiftUI

struct SettingsView: View {
    @State private var showAccountInfo = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.system(size: 25, weight: .heavy))
                        .padding(.top)
                    
                    SettingsSection(title: "General", items: [
                        SettingsItem(icon: "gearshape", title: "Account information", action: { showAccountInfo = true }),
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
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showAccountInfo) {
            AccountInformationView()
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
//                            .foregroundColor(.green)
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


struct AccountInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let darkGreenColor = Color(red: 0.06, green: 0.36, blue: 0.22)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: "https://images.pexels.com/photos/6273480/pexels-photo-6273480.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Image(systemName: "pencil.circle.fill")
                                            .foregroundColor(.green)
                                            .offset(x: 50, y: 50)
                                    )
                            case .failure(_):
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView()
                                    .frame(width: 120, height: 120)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mayu Yamaguchi")
                                .font(.system(size: 18, weight: .bold))
                            Text("she/her/hers")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "calendar")
                                Text("Join Date: 7/10/2024")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top)
                    
                    Divider()
                    
                    Text("General Info")
                        .font(.system(size: 18, weight: .bold))
                    
                    ForEach(["School", "Major", "Hobbies"], id: \.self) { item in
                        HStack {
                            Image(systemName: item == "School" ? "building.columns" : (item == "Major" ? "book" : "star"))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(darkGreenColor)
                                .clipShape(Circle())
                            Text(item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Account Information", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                    .clipShape(Circle())
            })
        }
    }
}


struct Account_Preview: PreviewProvider {
    static var previews: some View {
        AccountInformationView()
    }
}
