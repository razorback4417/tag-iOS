//
//  CreateView.swift
//  testing
//
//  Created by Theo L on 7/18/24.
//

import SwiftUI
import MapKit

struct IdentifiablePointAnnotation: Identifiable {
    let id = UUID()
    var annotation: MKPointAnnotation
}

struct CreateView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var tripViewModel: TripViewModel
    @Binding var isPresented: Bool
    @State private var currentStep = 1
    @State private var selection: String? = "Just me"
    @State private var pickupLocation = ""
    @State private var destination = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tripInfo: TripInfo?
    
    var onViewMyTrip: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress indicator (only shown for steps 1-4)
                if currentStep < 5 {
                    HStack(spacing: 10) {
                        ForEach(1...5, id: \.self) { step in
                            Rectangle()
                                .foregroundColor(step <= currentStep ? Color(red: 0.07, green: 0.36, blue: 0.22) : Color(red: 0.91, green: 0.91, blue: 0.91))
                                .frame(height: 5)
                                .cornerRadius(100)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                
                // Step content
                Group {
                    switch currentStep {
                    case 1:
                        Step1View(currentStep: $currentStep, selection: $selection)
                    case 2:
                        Step2View(currentStep: $currentStep, pickupLocation: $pickupLocation, destination: $destination)
                    case 3:
                        Step3View(currentStep: $currentStep, selectedDate: $selectedDate, selectedTime: $selectedTime)
                    case 4:
                        Step4View(currentStep: $currentStep, tripInfo: createTripInfo())
                    case 5:
                        Step5View(currentStep: $currentStep, onViewMyTrip: onViewMyTrip)
                    default:
                        EmptyView()
                    }
                }
                
                Spacer()
            }
            .navigationBarItems(
                leading: currentStep < 5 ? Button("Cancel") {
                    isPresented = false
                } : nil,
                trailing: (currentStep > 1 && currentStep < 5) ? Button(action: {
                    currentStep -= 1
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                        .clipShape(Circle())
                } : nil
            )
            .navigationBarTitle(currentStep < 5 ? "Create Trip" : "", displayMode: .inline)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func createTripInfo() -> TripInfo? {
        guard let user = userViewModel.user, let userId = user.id else {
            DispatchQueue.main.async {
                self.alertMessage = "User data not available. Please try again later."
                self.showAlert = true
            }
            return nil
        }
        
        let combinedDateTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: selectedTime),
                                                     minute: Calendar.current.component(.minute, from: selectedTime),
                                                     second: 0,
                                                     of: selectedDate) ?? selectedDate
        
        return TripInfo(
            hostId: userId,
            from: pickupLocation,
            to: destination,
            date: combinedDateTime,
            joinedUsers: [],
            totalSpots: 4,  // You can make this configurable if needed
            distance: "N/A",
            price: "N/A"
        )
    }
}

struct Step1View: View {
    @Binding var currentStep: Int
    @Binding var selection: String?
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("01")
                    .font(.system(size: 50, weight: .heavy))
                    .foregroundColor(.black)
                
                Text("Who is Tagging along?")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundColor(.black)
                
                Text("Select your current traveler count")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
            
            VStack(spacing: 10) {
                        SelectionButton(title: "Just me", subtitle: "Find other verified students to share the ride with", isSelected: selection == "Just me", action: { selection = "Just me" })
                        
                        SelectionButton(title: "Friends", subtitle: "Create a private trip with an invite code to send out", isSelected: selection == "Friends", action: { selection = "Friends" })
                    }
            .padding(.horizontal, 24)

//            if selection == "Just me", let user = userViewModel.user {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Host Information")
//                        .font(.headline)
//                    
//                    Text("Name: \(user.firstName) \(user.lastName)")
//                    Text("Phone: \(user.phoneNumber)")
//                }
//                .padding(.horizontal, 24)
//            }
            
            Spacer()
            
            Button(action: {
                currentStep += 1
            }) {
                Text("Next")
                    .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

struct SelectionButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Circle()
                    .fill(isSelected ? Color(red: 0.06, green: 0.36, blue: 0.22) : Color(red: 0.94, green: 0.96, blue: 0.95))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color(red: 0.07, green: 0.36, blue: 0.22) : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct Step2View: View {
    @Binding var currentStep: Int
    @Binding var pickupLocation: String
    @Binding var destination: String
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var pickupAnnotation: IdentifiablePointAnnotation?
    @State private var destinationAnnotation: IdentifiablePointAnnotation?
    @State private var showingPickupResults = false
    @State private var showingDestinationResults = false
    
    @StateObject private var placeViewModel = PlaceViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color.white.opacity(0.01) // Invisible background to catch taps
                .onTapGesture {
                    showingPickupResults = false
                    showingDestinationResults = false
                }

            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 5) {
                    Text("02")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.black)
                    
                    Text("Where are you going?")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.black)
                    
                    Text("Select your pickup and drop-off location")
                        .font(.custom("BeVietnamPro-Regular", size: 12))
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
                
                VStack(spacing: 12) {
                    // Pickup location input
                    HStack {
                        Image(systemName: "paperplane")
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        TextField("Pickup location", text: $pickupLocation)
                            .font(.custom("BeVietnamPro-Regular", size: 14))
                            .onChange(of: pickupLocation) { newValue in
                                placeViewModel.searchAddress(newValue)
                                showingPickupResults = true
                                showingDestinationResults = false
                            }
                    }
                    .padding()
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(8)

                    // Destination input
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        TextField("Destination", text: $destination)
                            .font(.custom("BeVietnamPro-Regular", size: 14))
                            .onChange(of: destination) { newValue in
                                placeViewModel.searchAddress(newValue)
                                showingDestinationResults = true
                                showingPickupResults = false
                            }
                    }
                    .padding()
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                
                // Map
                Map(coordinateRegion: $region, annotationItems: [pickupAnnotation, destinationAnnotation].compactMap { $0 }) { item in
                    MapMarker(coordinate: item.annotation.coordinate, tint: item.annotation == pickupAnnotation?.annotation ? .blue : .red)
                }
                .frame(height: 250)
                .cornerRadius(8)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Next button
                Button(action: {
                    currentStep += 1
                }) {
                    Text("Next")
                        .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 53)
                        .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            
            // Predictions overlay
            VStack {
                Spacer().frame(height: 210)
                if showingPickupResults && !placeViewModel.places.isEmpty {
                    predictionsListView(for: .pickup)
//                        .offset(y: 145)
                } else if showingDestinationResults && !placeViewModel.places.isEmpty {
                    predictionsListView(for: .destination)
//                        .offset(y: 205) // Adjust this value to position the list correctly
                }
                Spacer()
            }
            .zIndex(1)
        }
    }
    
    @ViewBuilder
    func predictionsListView(for type: PredictionType) -> some View {
        List(placeViewModel.places) { place in
            Text(place.name)
                .onTapGesture {
                    if type == .pickup {
                        pickupLocation = place.name
                        showingPickupResults = false
                    } else {
                        destination = place.name
                        showingDestinationResults = false
                    }
                    updateAnnotation(for: place.name, isPickup: type == .pickup)
                }
        }
        .frame(maxHeight: 200)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding(.horizontal, 24)
    }
    
    enum PredictionType {
        case pickup
        case destination
    }
    
    private func updateAnnotation(for address: String, isPickup: Bool) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let location = placemarks?.first?.location {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                let identifiableAnnotation = IdentifiablePointAnnotation(annotation: annotation)
                DispatchQueue.main.async {
                    if isPickup {
                        self.pickupAnnotation = identifiableAnnotation
                    } else {
                        self.destinationAnnotation = identifiableAnnotation
                    }
                    self.updateRegion()
                }
            }
        }
    }
    
    private func updateRegion() {
        if let pickup = pickupAnnotation?.annotation.coordinate, let destination = destinationAnnotation?.annotation.coordinate {
            let center = CLLocationCoordinate2D(
                latitude: (pickup.latitude + destination.latitude) / 2,
                longitude: (pickup.longitude + destination.longitude) / 2
            )
            let span = MKCoordinateSpan(
                latitudeDelta: abs(pickup.latitude - destination.latitude) * 1.5,
                longitudeDelta: abs(pickup.longitude - destination.longitude) * 1.5
            )
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
}

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    @Binding var pickupResults: [MKLocalSearchCompletion]
    @Binding var destinationResults: [MKLocalSearchCompletion]
    
    init(pickupResults: Binding<[MKLocalSearchCompletion]>, destinationResults: Binding<[MKLocalSearchCompletion]>) {
        _pickupResults = pickupResults
        _destinationResults = destinationResults
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        pickupResults = completer.results
        destinationResults = completer.results
    }
}

struct Step3View: View {
    @Binding var currentStep: Int
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 5) {
                        Text("03")
                            .font(.system(size: 50, weight: .heavy))
                            .foregroundColor(.black)
                        
                        Text("When are you going?")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.black)
                        
                        Text("Choose the date and time of your upcoming trip.")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    // Calendar
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(height: 300)
                    
                    // Time Picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Time")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.top, 20)
                        
                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 100)
                            .clipped()
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Next button
            Button(action: {
                currentStep += 1
            }) {
                Text("Next")
                    .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
}

struct Step4View: View {
    @Binding var currentStep: Int
    @EnvironmentObject private var tripViewModel: TripViewModel
    let tripInfo: TripInfo?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Group {
            if let tripInfo = tripInfo {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 5) {
                        Text("04")
                            .font(.system(size: 50, weight: .heavy))
                        
                        Text("Trip Summary")
                            .font(.system(size: 22, weight: .heavy))
                        
                        Text("Feel free to go back and edit your trip details")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    
                    // Trip details
                    VStack(alignment: .leading, spacing: 16) {
                        TripDetailRow(icon: "mappin.circle", title: "From", detail: tripInfo.from)
                        TripDetailRow(icon: "mappin.and.ellipse", title: "To", detail: tripInfo.to)
                        TripDetailRow(icon: "calendar", title: "Date", detail: formatDate(tripInfo.date))
                        TripDetailRow(icon: "clock", title: "Time", detail: formatTime(tripInfo.date))
                        TripDetailRow(icon: "person.3", title: "Spots", detail: tripInfo.spots)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Post trip button
                    Button(action: {
                        tripViewModel.createTrip(tripInfo)
                        currentStep += 1
                    }) {
                        Text("Post trip")
                            .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 53)
                            .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            } else {
                Text("Unable to create trip. Please try again.")
                    .padding()
                    .onAppear {
                        self.alertMessage = "Unable to create trip. Please try again."
                        self.showAlert = true
                    }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TripDetailRow: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                .frame(width: 45, height: 45)
                .background(Color(red: 0.94, green: 0.96, blue: 0.95))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Step5View: View {
    @Binding var currentStep: Int
    var onViewMyTrip: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
            
            Text("Your trip has been posted.")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("You are responsible for booking the\nride. See your trip for details.")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                print("Navigating to My Trips")
                onViewMyTrip()
            }) {
                Text("View my Trip")
                    .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(isPresented: .constant(true), onViewMyTrip: {})
            .environmentObject(UserViewModel())
            .environmentObject(TripViewModel())
    }
}


//
