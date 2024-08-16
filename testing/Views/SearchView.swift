//
//  SearchView.swift
//  testing
//
//  Created by Theo L on 7/19/24.
//
import SwiftUI
import MapKit

struct SearchView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var tripViewModel: TripViewModel
    @StateObject private var placeViewModel = PlaceViewModel()
    
    @State private var pickupLocation = ""
    @State private var destination = ""
    @State private var date = Date()
    
    @State private var showMyTrips = false
    @State private var showActiveTrips = false
    @State private var showSearchResults = false
    @State private var navigateToActiveTrips = false
    
    @State private var showingPickupResults = false
    @State private var showingDestinationResults = false
    @State private var showSettings = false
    
    @State private var refreshTrigger = false

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(red: 0.94, green: 0.94, blue: 0.94).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack(alignment: .top, spacing: 12) {
                            AsyncImage(url: URL(string: "https://images.pexels.com/photos/6273480/pexels-photo-6273480.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")) { phase in
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
                                Text("Hello \(userViewModel.user?.firstName ?? "there") 👋")
                                    .font(.custom("Be Vietnam Pro", size: 12))
                                    .foregroundColor(.black)
                                
                                Text("Where are you going?")
                                    .font(.custom("Be Vietnam Pro", size: 21).weight(.semibold))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "gearshape")
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                    .padding(6)
                                    .background(Color.black.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        
                        // Trip Info Card
                        VStack(spacing: 16) {
                            Text("Trip-Info")
                                .font(.custom("Manrope", size: 12).weight(.semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            
                            VStack(spacing: 12) {
                                // Pickup location input
                                locationInputField(title: "Pickup location", text: $pickupLocation, isPickup: true)
                                
                                // Destination input
                                locationInputField(title: "Destination", text: $destination, isPickup: false)
   
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
                            }
                            
                            Button(action: {
                                print("Searching now")
                                Task {
                                    await performSearch()
                                }
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
                .simultaneousGesture(
                    TapGesture().onEnded { _ in
                        showingPickupResults = false
                        showingDestinationResults = false
                    }
                )
                
                // Prediction results overlay
                VStack {
                    Spacer().frame(height: 240)
                    if showingPickupResults {
                        predictionResultsView(for: $pickupLocation, showResults: $showingPickupResults)
                    } else if showingDestinationResults {
                        predictionResultsView(for: $destination, showResults: $showingDestinationResults)
                    }
                    Spacer()
                }
                .zIndex(1)
                
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $showActiveTrips) {
                ActiveTripsView()
            }
            .navigationDestination(isPresented: $showMyTrips) {
                MyTripsView(refreshTrigger: $refreshTrigger)
                    .environmentObject(userViewModel)
            }
        }
    }
    func locationInputField(title: String, text: Binding<String>, isPickup: Bool) -> some View {
        HStack {
            Image(systemName: isPickup ? "mappin.circle.fill" : "mappin.and.ellipse")
                .foregroundColor(.gray)
            TextField(title, text: text)
                .font(.custom("Be Vietnam Pro", size: 16))
                .onChange(of: text.wrappedValue) { oldValue, newValue in
                    placeViewModel.searchAddress(newValue)
                    if isPickup {
                        showingPickupResults = true
                        showingDestinationResults = false
                    } else {
                        showingDestinationResults = true
                        showingPickupResults = false
                    }
                }
        }
        .padding()
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .cornerRadius(8)
    }
    
    func predictionResultsView(for text: Binding<String>, showResults: Binding<Bool>) -> some View {
        VStack {
            if !placeViewModel.places.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(placeViewModel.places) { place in
                        Text(place.name)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .onTapGesture {
                                text.wrappedValue = place.name
                                showResults.wrappedValue = false
                            }
                        
                        if place.id != placeViewModel.places.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func performSearch() async {
        print("Performing Search")
        print("Pickup Location: '\(pickupLocation)'")
        print("Destination: '\(destination)'")
        print("Date: \(dateFormatter.string(from: date))")
        await tripViewModel.searchTrips(from: pickupLocation, to: destination)
        print("Search initiated")
        
        // Navigate immediately
        DispatchQueue.main.async {
            self.navigateToActiveTrips = true
        }
    }
}

struct SearchResultsView: View {
    let trips: [TripInfo]
    @State private var refreshTrigger = false
    
    var body: some View {
        List(trips) { trip in
            NavigationLink(destination: TripDetailsView(isFromActiveTrips: true, trip: trip, refreshTrigger: $refreshTrigger)) {
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
