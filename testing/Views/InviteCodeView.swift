//
//  InviteCodeView.swift
//  testing
//
//  Created by Theo L on 8/16/24.
//

import SwiftUI

struct InviteCodeView: View {
    @State private var inviteCode: String = ""
    @State private var errorMessage: String? = nil
    @EnvironmentObject var tripViewModel: TripViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Invite Code")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Have your friend share the invite code with you and paste it below.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TextField("Invite Code", text: $inviteCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Join Trip") {
                joinTrip()
            }
            .padding()
            .background(Color(red: 0.06, green: 0.36, blue: 0.22))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func joinTrip() {
        guard let userId = userViewModel.user?.id else {
            errorMessage = "User not logged in."
            return
        }
        
        tripViewModel.joinTripByInviteCode(inviteCode: inviteCode, userId: userId) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    InviteCodeView()
}
