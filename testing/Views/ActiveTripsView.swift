//
//  ActiveTripsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct ActiveTripsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripViewModel: TripViewModel
    @State private var showCreateView = false
    
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
                    Text("All Active Trips")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(tripViewModel.searchResults) { trip in
                            NavigationLink(destination: TripDetailsView(isFromActiveTrips: true, trip: trip)) {
                                ActiveTripCard(trip: trip)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Create Trip Text
                Button(action: {
                    showCreateView = true
                }) {
                    Text("Can't Find a Trip? Create one here.")
                        .font(.custom("BeVietnamPro-Regular", size: 12))
                        .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            tripViewModel.fetchAllTrips()
        }
        .sheet(isPresented: $showCreateView) {
            CreateView(isPresented: $showCreateView, onViewMyTrip: {})
        }
    }
}

struct ActiveTripCard: View {
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
                    
                    Text("\(formatDate(trip.date)) | \(formatDistance(trip.distance)) miles")
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
        formatter.dateFormat = "h:mm a, EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    private func formatDistance(_ distance: Double) -> String {
        return String(format: "%.1f miles", distance)
    }
}

struct ActiveTripsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTripsView()
    }
}
