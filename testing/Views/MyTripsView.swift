//
//  MyTripsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct MyTripsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripViewModel: TripViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var createdTrips: [TripInfo] = []
    @State private var joinedTrips: [TripInfo] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @Binding var refreshTrigger: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.94, blue: 0.94).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                // Navigation bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("My Trips")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.custom("BeVietnamPro-Regular", size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if !tripViewModel.activeCreatedTrips.isEmpty {
                                Text("Created Trips")
                                    .font(.custom("Manrope-Regular", size: 15).weight(.bold))
                                    .padding(.leading)
                                
                                //                                ForEach(userViewModel.userTrips.created) { trip in
                                ForEach(tripViewModel.activeCreatedTrips) { trip in
                                    NavigationLink(destination: TripDetailsView(isFromActiveTrips: false, trip: trip, refreshTrigger: $refreshTrigger)) {
                                        TripCard(trip: trip)
                                    }
                                }
                            }
                            
                            if !tripViewModel.activeJoinedTrips.isEmpty {
                                Text("Joined Trips")
                                    .font(.custom("Manrope-Regular", size: 15).weight(.bold))
                                    .padding(.leading)
                                
                                //                                ForEach(userViewModel.userTrips.joined) { trip in
                                ForEach(tripViewModel.activeJoinedTrips) { trip in
                                    NavigationLink(destination: TripDetailsView(isFromActiveTrips: false, trip: trip, refreshTrigger: $refreshTrigger)) {
                                        TripCard(trip: trip)
                                    }
                                }
                            }
                            
                            if tripViewModel.activeCreatedTrips.isEmpty && tripViewModel.activeJoinedTrips.isEmpty {
                                Text("You haven't created or joined any trips yet.")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: loadTrips)
        .onChange(of: refreshTrigger) { _, _ in loadTrips() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            loadTrips()
        }
    }
    
    //    private func loadTrips() {
    //        isLoading = true
    //        errorMessage = nil
    //
    //        userViewModel.fetchUserTrips { result in
    //            DispatchQueue.main.async {
    //                self.isLoading = false
    //                switch result {
    //                case .success:
    //                    // The userTrips property in userViewModel is already updated
    //                    break
    //                case .failure(let error):
    //                    self.errorMessage = "Failed to load trips: \(error.localizedDescription)"
    //                }
    //            }
    //        }
    //    }
    
    private func loadTrips() {
        isLoading = true
        errorMessage = nil
        
        guard let userId = userViewModel.user?.id else {
            errorMessage = "Unable to fetch user information."
            isLoading = false
            return
        }
        
        tripViewModel.fetchActiveTrips(for: userId)
        
        // Use a DispatchQueue to check if the trips have been loaded after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second delay
            if self.tripViewModel.activeCreatedTrips.isEmpty && self.tripViewModel.activeJoinedTrips.isEmpty {
                // If both arrays are still empty after the delay, assume an error occurred
                self.errorMessage = "Failed to load trips. Please try again."
            }
            self.isLoading = false
        }
    }
    
    func refreshView() {
        refreshTrigger.toggle()
    }
}

struct TripCard: View {
    let trip: TripInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(trip.from)
                            .font(.custom("Manrope-Regular", size: 13).weight(.heavy))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                        Text(trip.to)
                            .font(.custom("Manrope-Regular", size: 13).weight(.heavy))
                    }
                    .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                    
                    Text("\(formatDate(trip.date)) | \(formatDistance(trip.distance))")
                        .font(.custom("BeVietnamPro-Regular", size: 8))
                        .foregroundColor(Color(red: 0.07, green: 0.36, blue: 0.22))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(trip.price)
                        .font(.custom("Manrope-Regular", size: 13).weight(.heavy))
                        .foregroundColor(Color(red: 0.07, green: 0.36, blue: 0.22))
                    Text(trip.spots)
                        .font(.custom("BeVietnamPro-Regular", size: 10).weight(.bold))
                        .foregroundColor(Color(red: 0.18, green: 0.81, blue: 0.50))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    private func formatDistance(_ distance: Double) -> String {
        return String(format: "%.1f miles", distance)
    }
}

//struct MyTripsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyTripsView()
//            .environmentObject(UserViewModel())
//    }
//}
