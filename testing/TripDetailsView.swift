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
    @State private var showingDeleteConfirmation = false

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
                Text(trip.distance) //to be calculated
                    .font(.custom("BeVietnamPro-Regular", size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                
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
                        Text("Duration 1h 05m") // You might want to calculate this dynamically
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
                        DetailRow(title: "Trip Owner", value: trip.hostId)
                        DetailRow(title: "Passengers", value: "\(trip.joinedUsers.count)/\(trip.totalSpots) students")
                        DetailRow(title: "Deadline", value: formatDate(trip.date.addingTimeInterval(-86400))) // 1 day before
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        DetailRow(title: "Price Estimate", value: trip.price)
                        DetailRow(title: "Trip Status", value: "Active")
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
                        tripViewModel.joinTrip(tripId: trip.id ?? "", userId: Auth.auth().currentUser?.uid ?? "")
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
                                tripViewModel.deleteTrip(tripId: trip.id ?? "", userId: Auth.auth().currentUser?.uid ?? "")
                                presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                } else if trip.joinedUsers.contains(Auth.auth().currentUser?.uid ?? "") {
                    Button(action: {
                        tripViewModel.leaveTrip(tripId: trip.id ?? "", userId: Auth.auth().currentUser?.uid ?? "")
                        presentationMode.wrappedValue.dismiss()
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
                }
            }
        }
        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
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

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockTrip = TripInfo(
            id: "mockId",
            hostId: "mockHostId",
            from: "Evans Hall",
            to: "SFO, Terminal Two",
            date: Date(),
            joinedUsers: [],
            totalSpots: 4,
            distance: "0.2 Miles from your current location",
            price: "$6.33"
        )
        
        let mockUserViewModel = UserViewModel()
        let mockTripViewModel = TripViewModel()
        
        return TripDetailsView(isFromActiveTrips: true, trip: mockTrip)
            .environmentObject(mockUserViewModel)
            .environmentObject(mockTripViewModel)
    }
}
