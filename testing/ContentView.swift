//
//  ContentView.swift
//  testing
//
//  Created by Theo L on 6/27/24.
//

//optino command left and right arrows

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        ZStack() {
//            VStack(alignment: .leading, spacing: 67) {
//                Text("TAG")
//                    .font(Font.custom("Be Vietnam Pro", size: 55).weight(.bold))
//                    .lineSpacing(23)
//                    .italic()
//                    .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
//                VStack(alignment: .leading, spacing: 21) {
//                    HStack(spacing: 10) {
//                        ZStack() {
//
//                        }
//                        .frame(width: 14, height: 14)
//                        Text("Username or Email")
//                            .font(Font.custom("Be Vietnam Pro", size: 12))
//                            .lineSpacing(24)
//                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
//                    }
//                    .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
//                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
//                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
//                    .cornerRadius(8)
//                    HStack(spacing: 10) {
//                        ZStack() {
//
//                        }
//                        .frame(width: 14, height: 14.70)
//                        Text("Password")
//                            .font(Font.custom("Be Vietnam Pro", size: 12))
//                            .lineSpacing(24)
//                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
//                    }
//                    .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
//                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
//                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
//                    .cornerRadius(8)
//                    HStack(spacing: 10) {
//                        Text("Login")
//                            .font(Font.custom("Be Vietnam Pro", size: 13).weight(.bold))
//                            .lineSpacing(18)
//                            .foregroundColor(.white)
//                    }
//                    .padding(EdgeInsets(top: 12, leading: 124, bottom: 12, trailing: 124))
//                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
//                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
//                    .cornerRadius(8)
//                }
//                .frame(maxWidth: .infinity, minHeight: 174, maxHeight: 174)
//            }
//            .frame(height: 284)
//            .offset(x: -0.50, y: -36)
//            Text("Don’t have an account? Register here.")
//                .font(Font.custom("Be Vietnam Pro", size: 14))
//                .lineSpacing(21)
//                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
//                .offset(x: 0, y: 333.50)
//            Text("Forgot password?")
//                .font(Font.custom("Be Vietnam Pro", size: 10))
//                .lineSpacing(21)
//                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
//                .offset(x: 2, y: 128.50)
//            ZStack() {
//                ZStack() {
//                    Text("9:41")
////                        .font(Font.custom("SF Pro", size: 17).weight())
//                        .lineSpacing(22)
//                        .foregroundColor(.black)
//                        .offset(x: 0.17, y: 2.34)
//                }
//                .frame(width: 140.50, height: 54)
//                .offset(x: -126.25, y: 0)
//                ZStack() {
//                    ZStack() {
//                        Rectangle()
//                            .foregroundColor(.clear)
//                            .frame(width: 25, height: 13)
//                            .cornerRadius(4.30)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 4.30)
//                                    .inset(by: 0.50)
//                                    .stroke(.black, lineWidth: 0.50)
//                            )
//                            .offset(x: -1.16, y: 0)
//                            .opacity(0.35)
//                        Rectangle()
//                            .foregroundColor(.clear)
//                            .frame(width: 21, height: 9)
//                            .background(.black)
//                            .cornerRadius(2.50)
//                            .offset(x: -1.16, y: 0)
//                    }
//                    .frame(width: 27.33, height: 13)
//                    .offset(x: 24.41, y: 2.50)
//                }
//                .frame(width: 140.50, height: 54)
//                .offset(x: 126.25, y: 0)
//            }
//            .frame(width: 393, height: 38)
//            .background(.white)
//            .offset(x: 0, y: -401)
//        }
//        .frame(width: 393, height: 852)
//        .background(.white)
//    }
//}
//
//
//
//
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//
