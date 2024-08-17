//
//  TripDetailsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI
import FirebaseAuth

struct TripDetailsView: View {
    let isFromActiveTrips: Bool
    let trip: TripInfo
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var tripViewModel: TripViewModel
    @Binding var refreshTrigger: Bool
    @State private var showingDeleteConfirmation = false
    @State private var showingLeaveConfirmation = false
    @State private var showingJoinedUsers = false
    @State private var hostName = ""
    @State private var joinedUserNames: [String] = []
    @State private var showHostProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Spacer().frame(height: 10)
            HStack() {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding(10)
                }
                Spacer()
                
                Text("Trip Details")
                    .font(.custom("Manrope-Regular", size: 17).weight(.bold))
                Spacer()
                Color.clear.frame(width: 40, height: 40) // For symmetry
            }
            .padding(.horizontal, 21)
            .padding(.vertical, 33)
            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
            
            // Trip details card
            VStack(alignment: .leading, spacing: 20) {
                
                if trip.isPrivate && trip.hostId == Auth.auth().currentUser?.uid {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Invite Code")
                            .font(.headline)
                        Text(trip.inviteCode ?? "N/A")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Share this code with friends to invite them to your trip.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                
                HStack {
                    
                    Text("\(trip.from) → \(trip.to)")
                        .font(.custom("Manrope-Regular", size: 18).weight(.heavy))
                        .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                }
                
                Text(formatDate(trip.date))
                    .font(.custom("BeVietnamPro-Regular", size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                
                // Time details
                HStack {
                    VStack(alignment: .leading) {
                        Text(formatTime(trip.date))
                            .font(.custom("BeVietnamPro-Regular", size: 10).weight(.bold))
                        Text("Departure")
                            .font(.custom("BeVietnamPro-Regular", size: 6))
                        Text(formatDateShort(trip.date))
                            .font(.custom("BeVietnamPro-Regular", size: 4))
                    }
                    Spacer()
                    VStack {
                        Text("Duration 1h 05m")
                            .font(.custom("BeVietnamPro-Regular", size: 6))
                        Image(systemName: "car.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(formatTime(trip.date.addingTimeInterval(3900))) // Adding 1h 05m
                            .font(.custom("BeVietnamPro-Regular", size: 10).weight(.bold))
                        Text("Arrival")
                            .font(.custom("BeVietnamPro-Regular", size: 6))
                        Text(formatDateShort(trip.date))
                            .font(.custom("BeVietnamPro-Regular", size: 4))
                    }
                }
                .foregroundColor(Color(red: 0.17, green: 0.77, blue: 0.48))
                
                // Trip details grid
                HStack(alignment: .top, spacing: 77) {
                    VStack(alignment: .leading, spacing: 5) {
                        DetailRow(title: "Trip Owner", value: hostName)
                            .onTapGesture {
                                showHostProfile = true
                            }
                            .sheet(isPresented: $showHostProfile) {
                                UserProfileView(userId: trip.hostId)
                            }
                        DetailRow(title: "Passengers", value: "\(trip.joinedUsers.count)/\(trip.totalSpots) students")
                        DetailRow(title: "Deadline", value: formatDate(trip.date.addingTimeInterval(-86400))) // 1 day before
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        DetailRow(title: "Price Estimate", value: trip.price)
                        DetailRow(title: "Trip Status", value: "Active")
                    }
                }
                
                // Joined Users Section
                if canViewJoinedUsers {
                    Button(action: {
                        showingJoinedUsers = true
                    }) {
                        Text("View Joined Users")
                            .font(.custom("BeVietnamPro-Regular", size: 14).weight(.medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 21)
            
            Text("Any Questions? FAQ")
                .font(.custom("BeVietnamPro-Regular", size: 10))
                .padding(.top, 20)
            
            Spacer()
            
            if isFromActiveTrips {
                if trip.hostId != Auth.auth().currentUser?.uid && !trip.joinedUsers.contains(Auth.auth().currentUser?.uid ?? "") {
                    Button(action: {
                        tripViewModel.joinTrip(tripId: trip.id ?? "", userId: Auth.auth().currentUser?.uid ?? "", userViewModel: userViewModel)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Join Trip")
                            .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 47)
                            .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                }
            } else { // From MyTripsView
                if trip.hostId == Auth.auth().currentUser?.uid {
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Text("Delete Trip")
                            .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: 350)
                            .frame(height: 47)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                        .alert(isPresented: $showingDeleteConfirmation) {
                            Alert(
                                title: Text("Delete Trip"),
                                message: Text("Are you sure you want to delete this trip?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    tripViewModel.deleteTrip(tripId: trip.id ?? "", userId: Auth.auth().currentUser?.uid ?? "", userViewModel: userViewModel)
                                    presentationMode.wrappedValue.dismiss()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                } else if trip.joinedUsers.contains(Auth.auth().currentUser?.uid ?? "") {
                    Button(action: {
                        showingLeaveConfirmation = true
                    }) {
                        Text("Leave Trip")
                            .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: 350)
                            .frame(height: 47)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                        .alert(isPresented: $showingLeaveConfirmation) {
                            Alert(
                                title: Text("Leave Trip"),
                                message: Text("Are you sure you want to leave this trip?"),
                                primaryButton: .destructive(Text("Leave")) {
                                    tripViewModel.leaveTrip(tripId: trip.id ?? "", userId: Auth.auth().currentUser?.uid ?? "", userViewModel: userViewModel) {
                                        userViewModel.refreshUserTrips()
                                        refreshTrigger.toggle()
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                }
            }
        }
        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {
            fetchHostName()
            fetchJoinedUserNames()
        }
        .sheet(isPresented: $showingJoinedUsers) {
            NavigationView {
                JoinedUsersView(joinedUserIds: trip.joinedUsers)
                    .environmentObject(userViewModel)
            }
        }
    }
    
    private var canViewJoinedUsers: Bool {
        let currentUserId = Auth.auth().currentUser?.uid
        return trip.hostId == currentUserId || trip.joinedUsers.contains(currentUserId ?? "")
    }
    
    private func fetchHostName() {
        userViewModel.fetchUserName(userId: trip.hostId) { name in
            self.hostName = name
        }
    }
    
    private func fetchJoinedUserNames() {
        if canViewJoinedUsers {
            userViewModel.fetchUserNames(userIds: trip.joinedUsers) { names in
                self.joinedUserNames = names
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: date)
    }
}

struct JoinedUsersView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    let joinedUserIds: [String]
    @State private var joinedUserNames: [String] = []
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if joinedUserNames.isEmpty {
                Text("No users have joined this trip yet.")
            } else {
                List(joinedUserIds.indices, id: \.self) { index in
                    NavigationLink(destination: UserProfileView(userId: joinedUserIds[index])) {
                        Text(joinedUserNames[index])
                    }
                }
            }
        }
        .navigationTitle("Joined Users")
        .onAppear(perform: loadUserNames)
    }
    
    private func loadUserNames() {
        isLoading = true
        userViewModel.fetchUserNames(userIds: joinedUserIds) { names in
            self.joinedUserNames = names.reversed()
            self.isLoading = false
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: -3) {
            Text(title)
                .font(.custom("BeVietnamPro-Regular", size: 8))
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            Text(value)
                .font(.custom("BeVietnamPro-Regular", size: 11).weight(.bold))
                .foregroundColor(Color(red: 0.07, green: 0.36, blue: 0.22))
        }
        .frame(height: 37)
    }
}
