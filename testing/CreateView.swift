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
                        Step1View()
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
                        Button("Next") {
                            currentStep += 1
                        }
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

struct Step1View: View {
    var body: some View {
        // Implement the content for step 1
        Text("Step 1: Who is Tagging along?")
    }
}

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
