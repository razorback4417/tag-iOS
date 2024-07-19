//
//  CreateView.swift
//  testing
//
//  Created by Theo L on 7/18/24.
//

import SwiftUI

import SwiftUI

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
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                SelectionButton(title: "Just me", subtitle: "Find other verified students to share the ride with", isSelected: selection == "Just me", action: { selection = "Just me" })
                
                SelectionButton(title: "Friends", subtitle: "Create a private trip with an invite code to send out", isSelected: selection == "Friends", action: { selection = "Friends" })
            }
            .padding(.horizontal)
            
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
            .padding(.horizontal)
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







//-----------------------------------------------------------------------------------------



struct CreateView: View {
    @Binding var isPresented: Bool
    @State private var currentStep = 1
    
    var body: some View {
        NavigationView {
            VStack {
                // Progress indicator
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { step in
                        Rectangle()
                            .foregroundColor(step <= currentStep ? Color(red: 0.07, green: 0.36, blue: 0.22) : Color(red: 0.91, green: 0.91, blue: 0.91))
                            .frame(height: 5)
                            .cornerRadius(100)
                    }
                }
                .padding()
                
                // Step content
                Group {
                    switch currentStep {
                    case 1:
                        Step1View(currentStep: $currentStep)
                    case 2:
                        Step2View()
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
                
                // Navigation buttons
                HStack {
                    if currentStep > 1 {
                        Button("Back") {
                            currentStep -= 1
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < 5 {
                        
                    } else {
                        Button("Finish") {
                            isPresented = false
                        }
                    }
                }
                .padding()
            }
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
            .navigationBarTitle("Create Trip", displayMode: .inline)
        }
    }
}

//struct Step1View: View {
//    var body: some View {
//        // Implement the content for step 1
//        Text("Step 1: Who is Tagging along?")
//    }
//}

struct Step2View: View {
    var body: some View {
        // Implement the content for step 2
        Text("Step 2: Where are you going?")
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
