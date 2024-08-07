//
//  ComingSoonView.swift
//  testing
//
//  Created by Theo L on 8/5/24.
//

import SwiftUI

struct ComingSoonView: View {
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.94, blue: 0.94).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                    Text("Coming soon!")
                        .font(.custom("BeVietnamPro-Regular", size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
        }
        .navigationTitle("Coming Soon")
    }
}
