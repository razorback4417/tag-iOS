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
                .font(.custom("BeVietnamPro-Regular", size: 28).weight(.bold))
            
            Text("Have your friend share the invite code with you and paste it below.")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                Image(systemName: "key.fill")
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .padding(.leading, 12)
                
                TextField("Invite Code", text: $inviteCode)
                    .font(.custom("BeVietnamPro-Regular", size: 16))
                    .padding(.vertical, 12)
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .cornerRadius(8)
            .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.custom("BeVietnamPro-Regular", size: 12))
            }
            
            Button(action: joinTrip) {
                Text("Join Trip")
                    .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 53)
                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
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
