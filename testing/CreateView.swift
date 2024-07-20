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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress indicator
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
                
                // Step content
                Group {
                    switch currentStep {
                    case 1:
                        Step1View(currentStep: $currentStep)
                    case 2:
                        Step2View(currentStep: $currentStep)
                    case 3:
                        Step3View()
                    case 4:
                        Step4View()
                    case 5:
                        Step5View()
                    default:
                        EmptyView()
                    }
                }
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: currentStep > 1 ? Button(action: {
                    currentStep -= 1
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                        .clipShape(Circle())
                } : nil
            )
            .navigationBarTitle("Create Trip", displayMode: .inline)
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
                    .font(.system(size: 15, weight: .bold))
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
                    .font(.custom("Be Vietnam Pro", size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            }
            .padding(.top, 20) // Add more spacing at the top
            .padding(.horizontal, 24) // Increase horizontal padding
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    TextField("Pickup location", text: $pickupLocation)
                        .font(.custom("Be Vietnam Pro", size: 14))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(8)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    TextField("Destination", text: $destination)
                        .font(.custom("Be Vietnam Pro", size: 14))
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
                    .font(.custom("Be Vietnam Pro", size: 15).weight(.bold))
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

struct Step2View_Previews: PreviewProvider {
    static var previews: some View {
        Step2View(currentStep: .constant(2))
    }
}

struct Step3View: View {
    var body: some View {
        // Implement the content for step 3
        Text("Step 3: When are you going?")
    }
}

struct Step4View: View {
    var body: some View {
        // Implement the content for step 4
        Text("Step 4: Trip Summary")
    }
}

struct Step5View: View {
    var body: some View {
        // Implement the content for step 5
        Text("Step 5: Trip Posted")
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(isPresented: .constant(true))
    }
}
