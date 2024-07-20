//
//  ActiveTripsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct ActiveTripsView: View {
    @Environment(\.dismiss) var dismiss
    
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
                        ActiveTripCard(from: "Evans Hall", to: "SFO, Terminal Two", date: "3PM, Thursday, July 11", distance: "0.1 Miles from your current location", price: "$8.45", spots: "2/4 spots")
                        ActiveTripCard(from: "Moffitt Library", to: "SFO, Terminal One", date: "9AM, Friday, July 12", distance: "0.2 Miles from your current location", price: "$7.32", spots: "3/4 spots")
                        ActiveTripCard(from: "I-House", to: "SFO, Terminal Four", date: "4PM, Thursday, July 11", distance: "0.5 Miles from your current location", price: "$3.45", spots: "3/4 spots")
                        ActiveTripCard(from: "2425 Prospect St.", to: "SFO, Terminal Six", date: "8PM, Saturday, July 13", distance: "0.6 Miles from your current location", price: "$12.20", spots: "1/4 spots")
                        ActiveTripCard(from: "Evans Hall", to: "SFO, Terminal Two", date: "8PM, Saturday, July 13", distance: "0.1 Miles from your current location", price: "$12.20", spots: "1/4 spots")
                        ActiveTripCard(from: "Main Stacks", to: "SFO, Terminal 2", date: "8PM, Saturday, July 13", distance: "0.15 Miles from your current location", price: "$12.20", spots: "1/4 spots")
                        ActiveTripCard(from: "Main Stacks", to: "SFO, Terminal 2", date: "8PM, Saturday, July 13", distance: "0.15 Miles from your current location", price: "$12.20", spots: "1/4 spots")
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ActiveTripCard: View {
    let from: String
    let to: String
    let date: String
    let distance: String
    let price: String
    let spots: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(from)
                            .font(.custom("Manrope-Regular", size: 13).weight(.heavy))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                        Text(to)
                            .font(.custom("Manrope-Regular", size: 13).weight(.heavy))
                    }
                    .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                    
                    Text("\(date) | \(distance)")
                        .font(.custom("BeVietnamPro-Regular", size: 8))
                        .foregroundColor(Color(red: 0.07, green: 0.36, blue: 0.22))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(price)
                        .font(.custom("Manrope-Regular", size: 13).weight(.heavy))
                        .foregroundColor(Color(red: 0.07, green: 0.36, blue: 0.22))
                    Text(spots)
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
}

struct ActiveTripsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTripsView()
    }
}
