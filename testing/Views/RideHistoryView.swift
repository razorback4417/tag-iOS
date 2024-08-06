//
//  RideHistoryView.swift
//  testing
//
//  Created by Theo L on 8/5/24.
//

import SwiftUI

struct RideHistoryView: View {
    @EnvironmentObject var tripViewModel: TripViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.94, blue: 0.94).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if tripViewModel.pastTrips.isEmpty {
                    Text("You don't have any past trips yet.")
                        .font(.custom("BeVietnamPro-Regular", size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(tripViewModel.pastTrips) { trip in
                                NavigationLink(destination: TripDetailsView(isFromActiveTrips: false, trip: trip)) {
                                    TripCard(trip: trip)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Ride History")
        .onAppear(perform: loadPastTrips)
    }
    
    private func loadPastTrips() {
        isLoading = true
        errorMessage = nil
        
        if let userId = userViewModel.user?.id {
            tripViewModel.fetchPastTrips(for: userId)
            isLoading = false
        } else {
            errorMessage = "Unable to fetch user information."
            isLoading = false
        }
    }
}
