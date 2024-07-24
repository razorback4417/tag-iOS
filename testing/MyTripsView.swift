//
//  MyTripsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct MyTripsView: View {
    @Environment(\.dismiss) var dismiss
    
    let createdTrips: [TripInfo] = [
        TripInfo(host: ["asdf", "asdf"], from: "Evans Hall", to: "SFO, Terminal Two", date: createDate(from: "3PM, Thursday, July 11"),  spots: "2/4 spots", distance: "0.2 Miles from your current location", price: "$8.45")
    ]
    
    let joinedTrips: [TripInfo] = [
        TripInfo(host: ["qwer", "qwer"], from: "Embarcadero", to: "2425 Prospect St",  date: createDate(from: "5PM, Thursday, July 11"), spots: "3/4 spots", distance: "0.2 Miles from your current location", price: "$6.33")
    ]
    
    var body: some View {
        NavigationView {
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
                    
                    Text("Created Trips")
                        .font(.custom("Manrope-Regular", size: 15).weight(.bold))
                        .padding(.leading)
                    
                    ForEach(createdTrips) { trip in
                        NavigationLink(destination: TripDetailsView(trip: trip)) {
                            TripCard(trip: trip)
                        }
                    }
                    
                    Text("Joined Trips")
                        .font(.custom("Manrope-Regular", size: 15).weight(.bold))
                        .padding(.leading)
                    
                    ForEach(joinedTrips) { trip in
                        NavigationLink(destination: TripDetailsView(trip: trip)) {
                            TripCard(trip: trip)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    static func createDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha, EEEE, MMMM d"
        return dateFormatter.date(from: string) ?? Date()
    }
}

struct TripCard: View {
    let trip: TripInfo
    
    var body: some View {
        NavigationLink(destination: TripDetailsView(trip: trip)) {
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
                        
                        Text("\(trip.date) | \(trip.distance)")
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
        .buttonStyle(PlainButtonStyle())
    }
}
struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}

