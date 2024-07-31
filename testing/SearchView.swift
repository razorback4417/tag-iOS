//
//  SearchView.swift
//  testing
//
//  Created by Theo L on 7/19/24.
//
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var tripViewModel: TripViewModel
    
    @State private var pickupLocation = ""
    @State private var destination = ""
    
    @State private var date = Date()
    
    @State private var showMyTrips = false
    @State private var showActiveTrips = false
    @State private var showSearchResults = false
    
    
    @State private var navigateToActiveTrips = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.94, green: 0.94, blue: 0.94).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Header
                    HStack(alignment: .top, spacing: 12) {
                        AsyncImage(url: URL(string: "https://i.ibb.co/SBnxXDB/Screenshot-2024-07-19-at-2-45-05-PM.png")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 52, height: 52)
                                    .clipShape(Circle())
                            case .failure(_):
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 52, height: 52)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView()
                                    .frame(width: 52, height: 52)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello Theo 👋")
                                .font(.custom("Be Vietnam Pro", size: 12))
                                .foregroundColor(.black)
                            
                            Text("Where are you going?")
                                .font(.custom("Be Vietnam Pro", size: 21).weight(.semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                            .padding(6)
                            .background(Color.black.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    
                    // Trip Info Card
                    VStack(spacing: 16) {
                        Text("Trip-Info")
                            .font(.custom("Manrope", size: 12).weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.gray)
                                TextField("Pickup location", text: $pickupLocation)
                                    .font(.custom("Be Vietnam Pro", size: 16))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                TextField("Destination", text: $destination)
                                    .font(.custom("Be Vietnam Pro", size: 16))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .font(.custom("Be Vietnam Pro", size: 16))
                                Spacer()
                                Text(dateFormatter.string(from: date))
                                    .font(.custom("Be Vietnam Pro", size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            
//                            HStack(spacing: 12) {
//                                HStack {
//                                    Image(systemName: "calendar")
//                                        .foregroundColor(.gray)
//                                    DatePicker("", selection: $date, displayedComponents: .date)
//                                        .labelsHidden()
//                                        .font(.custom("Be Vietnam Pro", size: 16))
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(8)
//                                
//                                HStack {
//                                    Image(systemName: "clock")
//                                        .foregroundColor(.gray)
//                                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
//                                        .labelsHidden()
//                                        .font(.custom("Be Vietnam Pro", size: 16))
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(8)
//                            }
//                            if !tripViewModel.searchResults.isEmpty {
//                                Text("Search Results:")
//                                List(tripViewModel.searchResults) { trip in
//                                    Text("\(trip.from) to \(trip.to) on \(trip.date)")
//                                }
//                            }
                        }
                        
                        Button(action: {
//                            print("Navigating to my trips")
//                            showActiveTrips = true
                            print("Searching now")
                            performSearch()
                        }) {
                            Text("Search")
                                .font(.custom("Be Vietnam Pro", size: 16).weight(.medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showMyTrips = true
                        }) {
                            Text("My Trips")
                                .font(.custom("Be Vietnam Pro", size: 16).weight(.medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    NavigationLink(destination: ActiveTripsView().environmentObject(tripViewModel), isActive: $navigateToActiveTrips) {
                       EmptyView()
                   }
                }
                .padding(.top, 60)
            }
            .navigationDestination(isPresented: $showActiveTrips) {
                ActiveTripsView()
            }
            .navigationDestination(isPresented: $showMyTrips) {
                MyTripsView()
                    .environmentObject(userViewModel)
            }
        }
    }
//    private func performSearch() {
//        print("Performing Search")
//        print("TripViewModel: \(tripViewModel)")
//        print("Pickup Location: '\(pickupLocation)'")
//        print("Destination: '\(destination)'")
//        print("Date: \(dateFormatter.string(from: date))")
//        
//        // Check if inputs are not empty
//        guard !pickupLocation.isEmpty, !destination.isEmpty else {
//            print("Error: Pickup location or destination is empty")
//            return
//        }
//        
//        tripViewModel.searchTrips(from: pickupLocation, to: destination)
//        print("Search initiated")
//        
//        // Add a delay and then check results
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            print("Search Results Count: \(self.tripViewModel.searchResults.count)")
//            print("Search Results: \(self.tripViewModel.searchResults)")
//            
//            if !self.tripViewModel.searchResults.isEmpty {
//                self.navigateToActiveTrips = true
//            }
//        }
//    }
    private func performSearch() {
        print("Performing Search")
        print("Pickup Location: '\(pickupLocation)'")
        print("Destination: '\(destination)'")
        print("Date: \(dateFormatter.string(from: date))")
        
//        guard !pickupLocation.isEmpty, !destination.isEmpty else {
//            print("Error: Pickup location or destination is empty")
//            return
//        }
        
        tripViewModel.searchTrips(from: pickupLocation, to: destination)
        print("Search initiated")
        
        // Navigate immediately
        DispatchQueue.main.async {
            self.navigateToActiveTrips = true
        }
    }
}

struct SearchResultsView: View {
    let trips: [TripInfo]
    
    var body: some View {
        List(trips) { trip in
            NavigationLink(destination: TripDetailsView(isFromActiveTrips: true, trip: trip)) {
                TripCard(trip: trip)
            }
        }
        .navigationTitle("Search Results")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(UserViewModel())
            .environmentObject(TripViewModel())
    }
}


