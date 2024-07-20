//
//  AccountInformationView.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import SwiftUI

struct AccountInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let darkGreenColor = Color(red: 0.06, green: 0.36, blue: 0.22)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: "https://images.pexels.com/photos/6273480/pexels-photo-6273480.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Image(systemName: "pencil.circle.fill")
                                            .foregroundColor(.green)
                                            .offset(x: 40, y: 50)
                                    )
                            case .failure(_):
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView()
                                    .frame(width: 120, height: 120)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mayu Yamaguchi")
                                .font(.system(size: 18, weight: .bold))
                            Text("she/her/hers")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "calendar")
                                Text("Join Date: 7/10/2024")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top)
                    
                    Divider()
                    
                    Text("General Info")
                        .font(.system(size: 18, weight: .bold))
                    
                    ForEach(["School", "Major", "Interests"], id: \.self) { item in
                        HStack {
                            Image(systemName: item == "School" ? "building.columns" : (item == "Major" ? "book" : "star"))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(darkGreenColor)
                                .clipShape(Circle())
                            Text(item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Account Information", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .padding(8)
            })
        }
    }
}


struct Account_Preview: PreviewProvider {
    static var previews: some View {
        AccountInformationView()
    }
}
