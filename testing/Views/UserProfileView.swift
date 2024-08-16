//
//  UserProfileView.swift
//  testing
//
//  Created by Theo L on 8/1/24.
//

import SwiftUI

struct UserProfileView: View {
    let userId: String
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var user: User?
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    ProgressView()
                } else if let user = user {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: "https://images.pexels.com/photos/6273480/pexels-photo-6273480.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
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
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.system(size: 18, weight: .bold))
                            Text(user.gender)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "calendar")
                                Text("Join Date: 7/10/2024") // may add to User model
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top)
                    
                    Divider()
                    
                    Text("General Info")
                        .font(.system(size: 18, weight: .bold))
                    
                    ForEach([
                        "School: \(user.school)",
                        "Major: \(user.major)",
                        "Phone: \(user.phoneNumber)",  // Add this line
                        "Interests: \(user.interests.joined(separator: ", "))"
                    ], id: \.self) { item in
                        HStack {
                            Image(systemName: item.hasPrefix("School") ? "building.columns" :
                                    (item.hasPrefix("Major") ? "book" :
                                        (item.hasPrefix("Phone") ? "phone.fill" : "star")))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                            .clipShape(Circle())
                            Text(item)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                } else {
                    Text("User not found")
                }
            }
            .padding()
        }
        .navigationBarTitle("User Profile", displayMode: .inline)
        .onAppear {
            fetchUserProfile()
        }
    }
    
    private func fetchUserProfile() {
        isLoading = true
        userViewModel.fetchUserProfile(userId: userId) { result in
            isLoading = false
            switch result {
            case .success(let fetchedUser):
                self.user = fetchedUser
            case .failure(let error):
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }
}
