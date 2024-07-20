//
//  CreateView.swift
//  testing
//
//  Created by Theo L on 7/18/24.
//

import SwiftUI

struct CreateView: View {
    @Binding var isPresented: Bool
    @State private var currentStep = 1
    
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
                        Step1View(currentStep: $currentStep)
                    case 2:
                        Step2View(currentStep: $currentStep)
                    case 3:
                        Step3View(currentStep: $currentStep)
                    case 4:
                        Step4View(currentStep: $currentStep)
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
    }
}

struct Step1View: View {
    @Binding var currentStep: Int
    @State private var selection: String? = "Just me"
    
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
            .padding(.horizontal, 24) // Increase horizontal padding
            
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
    @State private var pickupLocation = ""
    @State private var destination = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            .padding(.top, 20) // Add more spacing at the top
            .padding(.horizontal, 24) // Increase horizontal padding
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    TextField("Pickup location", text: $pickupLocation)
                        .font(.custom("BeVietnamPro-Regular", size: 14))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    TextField("Destination", text: $destination)
                        .font(.custom("BeVietnamPro-Regular", size: 14))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(8)
            }
            .padding(.horizontal, 24) // Increase horizontal padding
            
            // Map placeholder
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 250) // Reduce height slightly
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(8)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
                
                Text("Map Placeholder")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Navigation button
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

struct Step3View: View {
    @Binding var currentStep: Int
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            .padding(.horizontal, 24)
            
            // Calendar
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("July 2024")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                    HStack(spacing: 20) {
                        Image(systemName: "chevron.left")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.blue)
                }
                
                // Custom calendar view would go here
                // For now, we'll use a placeholder
                Rectangle()
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .frame(height: 250)
                    .cornerRadius(13)
                    .overlay(
                        Text("Custom Calendar Placeholder")
                            .foregroundColor(.gray)
                    )
            }
            .padding(.horizontal, 24)
            
            // Time Picker
            VStack(alignment: .leading, spacing: 10) {
                Text("Time")
                    .font(.system(size: 17, weight: .semibold))
                
                HStack {
                    Text("9:41 PM")
                        .font(.system(size: 17))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .cornerRadius(8)
                    
                    Spacer()
                }
            }
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
    }
}

struct Step4View: View {
    @Binding var currentStep: Int
    
    var body: some View {
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
                TripDetailRow(icon: "briefcase", title: "Pickup Location", detail: "Evans Hall 9")
                TripDetailRow(icon: "mappin.and.ellipse", title: "Drop-off Location", detail: "Twin Peaks, California")
                TripDetailRow(icon: "clock", title: "Wed, Jun 26", detail: "8:00 AM PST")
                TripDetailRow(icon: "dollarsign.circle", title: "Price Estimate", detail: "Based on Uber API: $13.95")
                TripDetailRow(icon: "calendar", title: "Deadline", detail: "Others will be able to join your trip up to 2\nhours before.")
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Post trip button
            Button(action: {
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
    }
}
