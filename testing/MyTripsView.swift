//
//  MyTripsView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct MyTripsView: View {
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
                    Text("My Trips")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                
                Text("Created Trips")
                    .font(.custom("Manrope-Regular", size: 15).weight(.bold))
                    .padding(.leading)
                
                TripCard(from: "Evans Hall", to: "SFO, Terminal Two", date: "3PM, Thursday, July 11", distance: "0.2 Miles from your current location", price: "$8.45", spots: "2/4 spots")
                
                Text("Joined Trips")
                    .font(.custom("Manrope-Regular", size: 15).weight(.bold))
                    .padding(.leading)
                
                TripCard(from: "Embarcadero", to: "2425 Prospect St", date: "9PM, Tuesday, July 9", distance: "0.2 Miles from your current location", price: "$6.33", spots: "3/4 spots")
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct TripCard: View {
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

struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}
