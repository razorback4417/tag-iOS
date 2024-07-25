//
//  TripDetailsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct TripDetailsView: View {
    let trip: TripInfo
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Spacer()
                    .frame(height: 10)
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
                Text("0.2 Miles from your current location")
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
                        Text("3:00 PM")
                            .font(.custom("BeVietnamPro-Regular", size: 10).weight(.bold))
                        Text("Departure")
                            .font(.custom("BeVietnamPro-Regular", size: 6))
                        Text("Thurs, Jul 11")
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
                        Text("4:05 PM")
                            .font(.custom("BeVietnamPro-Regular", size: 10).weight(.bold))
                        Text("Arrival")
                            .font(.custom("BeVietnamPro-Regular", size: 6))
                        Text("Thurs, Jul 11")
                            .font(.custom("BeVietnamPro-Regular", size: 4))
                    }
                }
                .foregroundColor(Color(red: 0.17, green: 0.77, blue: 0.48))
                
                // Trip details grid
                HStack(alignment: .top, spacing: 77) {
                    VStack(alignment: .leading, spacing: 5) {
                        DetailRow(title: "Trip Owner", value: "Theo")
                        DetailRow(title: "Passengers", value: "3/4 students")
                        DetailRow(title: "Deadline", value: "3:00 PM Weds, July 10")
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        DetailRow(title: "Price Estimate", value: "$6.33")
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

            // Join trip button
            Button(action: {
                // Action to join trip
            }) {
                Text("Join trip")
                    .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 47)
                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            Spacer()
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
        TripDetailsView(trip: TripInfo(
            id: nil,
            hostId: "asdf",
            from: "Evans Hall",
            to: "SFO, Terminal Two",
            date: Date(), // Use the current date for the preview
            joinedUsers: [],
            totalSpots: 4,
            distance: "0.2 Miles from your current location",
            price: "$6.33"
        ))
    }
}
