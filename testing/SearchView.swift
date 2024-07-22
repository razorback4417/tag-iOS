//
//  SearchView.swift
//  testing
//
//  Created by Theo L on 7/19/24.
//
import SwiftUI

struct SearchView: View {
    @State private var pickupLocation = ""
    @State private var destination = ""
    @State private var date = ""
    @State private var time = ""
    
    @State private var showMyTrips = false
    @State private var showActiveTrips = false
    
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
                            
                            HStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                    TextField("Date", text: $date)
                                        .font(.custom("Be Vietnam Pro", size: 16))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.gray)
                                    TextField("Time", text: $time)
                                        .font(.custom("Be Vietnam Pro", size: 16))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        
                        Button(action: {
                            print("Navigating to my trips")
                            showActiveTrips = true
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
                }
                .padding(.top, 60)
            }
            .navigationDestination(isPresented: $showActiveTrips) {
                ActiveTripsView()
            }
            .navigationDestination(isPresented: $showMyTrips) {
                MyTripsView()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


