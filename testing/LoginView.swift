//
//  LoginView.swift
//  testing
//
//  Created by Theo L on 7/12/24.
//
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    
//    @StateObject private var userViewModel = UserViewModel() JUST REPLACED 4:30
    @State private var path = NavigationPath()
    
    @State private var username = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    
    //NEW BODY
    var body: some View {
            Group {
                if userViewModel.isLoggedIn {
                    MainTabView()
                } else {
                    loginContent
                }
            }
        }
    
//    var body: some View {
    var loginContent: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("TAG")
                        .font(Font.custom("BeVietnamPro-Regular", size: 55).weight(.heavy))
                        .italic()
                        .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                        .lineSpacing(23)
                        .padding(20)
                    
                    VStack(spacing: 21) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                            TextField("Email", text: $email)
                                .font(Font.custom("BeVietnamPro-Regular", size: 12))
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        }
                        .padding()
                        .frame(height: 44)
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .cornerRadius(8)
                        
                        HStack {
                            Image(systemName: "key")
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                            SecureField("Password", text: $password)
                                .font(Font.custom("BeVietnamPro-Regular", size: 12))
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        }
                        .padding()
                        .frame(height: 44)
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .cornerRadius(8)
                        
                        Button(action: {
                            // Handle login action
                            print("Here in login")
                            userViewModel.signIn(email: email, password: password)
                            //isLoggedIn = true
                        }) {
                            Text("Login")
                                .font(Font.custom("BeVietnamPro-Regular", size: 13).weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        // Handle forgot password action
                    }) {
                        Text("Forgot password?")
                            .font(Font.custom("BeVietnamPro-Regular", size: 10))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        path.append("RegistrationView1")
                    }) {
                        Text("Don't have an account? Register ")
                            .font(Font.custom("BeVietnamPro-Regular", size: 14))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        +
                        Text("here.")
                            .font(Font.custom("BeVietnamPro-Regular", size: 14).weight(.heavy))
                            .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "RegistrationView1":
                    RegistrationView1(userViewModel: userViewModel, path: $path)
                case "RegistrationView2":
                    RegistrationView2(userViewModel: userViewModel, path: $path)
                case "RegistrationView3":
                    RegistrationView3(userViewModel: userViewModel, path: $path)
                case "RegistrationConfirmView":
                    RegistrationConfirmView(path: $path)
                default:
                    EmptyView()
                }
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                MainTabView()
            }
        }
    }
}

struct RegistrationView1: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                    .cornerRadius(20)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                
                Text("Registration (1/3)")
                    .font(Font.custom("BeVietnamPro-Regular", size: 20).weight(.heavy))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Text("Make sure to use your school email so we can verify your student status.")
                    .font(Font.custom("BeVietnamPro-Regular", size: 11))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.horizontal, 40)
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        InputField(icon: "person", placeholder: "Name", text: $name)
                        InputField(icon: "person", placeholder: "Surname", text: $surname)
                    }
                    
                    InputField(icon: "envelope", placeholder: "Email", text: $email)
                    InputField(icon: "person.circle", placeholder: "Username", text: $username)
                    InputField(icon: "phone", placeholder: "XXX-XXX-XXXX", text: $phone)
                    InputField(icon: "key", placeholder: "Password", text: $password, isSecure: true)
                    InputField(icon: "key", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                Button(action: {
                    let step1Data = RegistrationStep1Data(
                        name: name,
                        surname: surname,
                        email: email,
                        username: username,
                        phone: phone,
                        password: password
                    )
                    userViewModel.startRegistration(step1Data: step1Data)
                    path.append("RegistrationView2")
                }) {
                    Text("Next")
                        .font(Font.custom("BeVietnamPro-Regular", size: 13).weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                        .cornerRadius(8)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegistrationView2: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    
    @Environment(\.presentationMode) var presentationMode
    @State private var gender = ""
    @State private var major = ""
    @State private var school = ""
    @State private var interests = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                    .cornerRadius(20)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                
                Text("Registration (2/3)")
                    .font(Font.custom("BeVietnamPro-Regular", size: 20).weight(.heavy))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Text("See our Privacy Policy on why we gather the following information.")
                    .font(Font.custom("BeVietnamPro-Regular", size: 11))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.horizontal, 40)
                
                VStack(spacing: 20) {
                    InputField(icon: "person", placeholder: "Gender", text: $gender)
                    InputField(icon: "book", placeholder: "Major", text: $major)
                    InputField(icon: "building.columns", placeholder: "School", text: $school)
                    InputField(icon: "star", placeholder: "Interests", text: $interests)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)

                Button(action: {
                    let step2Data = RegistrationStep2Data(
                        gender: gender,
                        major: major,
                        school: school,
                        interests: interests
                    )
                    userViewModel.continueRegistration(step2Data: step2Data)
                    path.append("RegistrationView3")
                }) {
                    Text("Next")
                        .font(Font.custom("BeVietnamPro-Regular", size: 13).weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                        .cornerRadius(8)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Text("Already have an account? Login here.")
                    .font(Font.custom("BeVietnamPro-Regular", size: 14))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegistrationView3: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    
    @Environment(\.presentationMode) var presentationMode
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var securityCode = ""
    @State private var cardholderName = ""
    
    @State private var navigateToConfirmation = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                    .cornerRadius(20)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                
                Text("Registration (3/3)")
                    .font(Font.custom("BeVietnamPro-Regular", size: 20).weight(.heavy))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Text("See our Privacy Policy on why we gather the following information.")
                    .font(Font.custom("BeVietnamPro-Regular", size: 11))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.horizontal, 40)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Card number")
                            .font(Font.custom("BeVietnamPro-Regular", size: 15))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        InputField(icon: "creditcard", placeholder: "0000 0000 0000 0000", text: $cardNumber)
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Expires")
                                .font(Font.custom("BeVietnamPro-Regular", size: 15))
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                            InputField(icon: "calendar", placeholder: "MM / YY", text: $expiryDate)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Security code")
                                .font(Font.custom("BeVietnamPro-Regular", size: 15))
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                            InputField(icon: "lock", placeholder: "CVC", text: $securityCode)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Cardholder name")
                            .font(Font.custom("BeVietnamPro-Regular", size: 15))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        InputField(icon: "person", placeholder: "Full Name", text: $cardholderName)
                    }
                    Button(action: {
                        // Handle create account action
                        userViewModel.finishRegistration()
                        path.append("RegistrationConfirmView")
                        print("Account Created")
                    }) {
                        Text("Create Account")
                            .font(Font.custom("BeVietnamPro-Regular", size: 13).weight(.bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                            .cornerRadius(8)
                    }
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        Text("Your transaction is secured with SSL encryption")
                            .font(Font.custom("BeVietnamPro-Regular", size: 12))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Text("Already have an account? Login here.")
                    .font(Font.custom("BeVietnamPro-Regular", size: 14))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
}

struct RegistrationConfirmView: View {
//    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 136, height: 136)
                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
            
            Text("Your account has been created.")
                .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                .multilineTextAlignment(.center)
            
            Text("Please login to your account to get started.")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                print("Account Creation Confirmed")
                path = NavigationPath()
                print("Path cleared")
            }) {
                NavigationLink(destination: LoginView()) {
                    Text("Login to my account")
                        .font(.custom("BeVietnamPro-Regular", size: 15).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 53)
                        .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(Font.custom("BeVietnamPro-Regular", size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            } else {
                TextField(placeholder, text: $text)
                    .font(Font.custom("BeVietnamPro-Regular", size: 12))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            }
        }
        .padding()
        .frame(height: 44)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .cornerRadius(8)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
//
//struct RegistrationView1_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RegistrationView1()
//        }
//    }
//}
//
//struct RegistrationView2_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RegistrationView2()
//        }
//    }
//}
//
//struct RegistrationView3_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RegistrationView3()
//        }
//    }
//}
//
//struct RegistrationConfirmView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RegistrationConfirmView()
//        }
//    }
//}

struct RegistrationView1_Previews: PreviewProvider {
    @State static var previewPath = NavigationPath()
    
    static var previews: some View {
        NavigationStack(path: $previewPath) {
            RegistrationView1(userViewModel: UserViewModel(), path: $previewPath)
        }
    }
}

struct RegistrationView2_Previews: PreviewProvider {
    @State static var previewPath = NavigationPath()
    
    static var previews: some View {
        NavigationStack(path: $previewPath) {
            RegistrationView2(userViewModel: UserViewModel(), path: $previewPath)
        }
    }
}

struct RegistrationView3_Previews: PreviewProvider {
    @State static var previewPath = NavigationPath()
    
    static var previews: some View {
        NavigationStack(path: $previewPath) {
            RegistrationView3(userViewModel: UserViewModel(), path: $previewPath)
        }
    }
}

struct RegistrationConfirmView_Previews: PreviewProvider {
    @State static var previewPath = NavigationPath()
    
    static var previews: some View {
        NavigationStack(path: $previewPath) {
            RegistrationConfirmView(path: $previewPath)
        }
    }
}
