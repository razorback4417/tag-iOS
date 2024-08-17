//
//  LoginView.swift
//  testing
//
//  Created by Theo L on 7/12/24.
//
//
import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var path = NavigationPath()
    @State private var email = ""
    @State private var password = ""
    @State private var showingForgotPassword = false
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @FocusState private var focusedField: FocusField?
    
    enum FocusField: Hashable {
        case email, password
    }
    
    var body: some View {
        Group {
            if userViewModel.isLoggedIn {
                MainTabView()
            } else {
                loginContent
            }
        }
    }
    
    var loginContent: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 30) {
                            Text("TAG")
                                .font(.custom("BeVietnamPro-Regular", size: 55))
                                .fontWeight(.heavy)
                                .italic()
                                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                            
                            VStack(spacing: 20) {
                                InputField(icon: "envelope", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit { focusedField = .password }
                                
                                InputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit(login)
                            }
                            
                            Button(action: login) {
                                Text("Login")
                                    .font(.custom("BeVietnamPro-Regular", size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 53)
                                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                    .cornerRadius(8)
                            }
                            
                            Button("Forgot password?") {
                                showingForgotPassword = true
                            }
                            .font(.custom("BeVietnamPro-Regular", size: 14))
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                        
                        Button(action: {
                            path.append("RegistrationView1")
                        }) {
                            Text("Don't have an account? Register ")
                                .font(.custom("BeVietnamPro-Regular", size: 14))
                                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46)) +
                            Text("here")
                                .font(.custom("BeVietnamPro-Regular", size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
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
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func login() {
        userViewModel.signIn(email: email, password: password)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !userViewModel.isLoggedIn {
                alertMessage = "Login failed. Please check your credentials and try again."
                showingAlert = true
            }
        }
    }
}

struct RegistrationView1: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name, surname, email, username, phone, password, confirmPassword
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Registration (1/3)")
                            .font(.custom("BeVietnamPro-Regular", size: 24))
                            .fontWeight(.bold)
                        
                        Text("Make sure to use your school email so we can verify your student status.")
                            .font(.custom("BeVietnamPro-Regular", size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            InputField(icon: "person", placeholder: "Name", text: $name)
                                .focused($focusedField, equals: .name)
                            InputField(icon: "person", placeholder: "Surname", text: $surname)
                                .focused($focusedField, equals: .surname)
                            InputField(icon: "envelope", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                                .focused($focusedField, equals: .email)
                            InputField(icon: "person.circle", placeholder: "Username", text: $username)
                                .focused($focusedField, equals: .username)
                            InputField(icon: "phone", placeholder: "Phone", text: $phone, keyboardType: .phonePad)
                                .focused($focusedField, equals: .phone)
                            InputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                                .focused($focusedField, equals: .password)
                            InputField(icon: "lock", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                                .focused($focusedField, equals: .confirmPassword)
                        }
                        
                        Button(action: nextStep) {
                            Text("Next")
                                .font(.custom("BeVietnamPro-Regular", size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 53)
                                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .frame(minHeight: geometry.size.height - 60) // Subtract height of bottom link
                }
                
                bottomLink
            }
            .frame(height: geometry.size.height)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(path: $path))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    var bottomLink: some View {
        Button(action: { path = NavigationPath() }) {
            Text("Already have an account? Login ")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46)) +
            Text("here")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
    
    private func nextStep() {
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
    }
}

struct RegistrationView2: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    
    @State private var gender = ""
    @State private var major = ""
    @State private var school = ""
    @State private var interests = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case gender, major, school, interests
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Registration (2/3)")
                            .font(.custom("BeVietnamPro-Regular", size: 24))
                            .fontWeight(.bold)
                        
                        Text("See our Privacy Policy on why we gather the following information.")
                            .font(.custom("BeVietnamPro-Regular", size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            InputField(icon: "person", placeholder: "Gender", text: $gender)
                                .focused($focusedField, equals: .gender)
                            InputField(icon: "book", placeholder: "Major", text: $major)
                                .focused($focusedField, equals: .major)
                            InputField(icon: "building.columns", placeholder: "School", text: $school)
                                .focused($focusedField, equals: .school)
                            InputField(icon: "star", placeholder: "Interests (comma separated)", text: $interests)
                                .focused($focusedField, equals: .interests)
                        }
                        
                        Button(action: nextStep) {
                            Text("Next")
                                .font(.custom("BeVietnamPro-Regular", size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 53)
                                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .frame(minHeight: geometry.size.height - 60) // Subtract height of bottom link
                }
                
                bottomLink
            }
            .frame(height: geometry.size.height)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(path: $path))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    var bottomLink: some View {
        Button(action: { path = NavigationPath() }) {
            Text("Already have an account? Login ")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46)) +
            Text("here")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
    
    private func nextStep() {
        // Validation logic here
        let step2Data = RegistrationStep2Data(
            gender: gender,
            major: major,
            school: school,
            interests: interests
        )
        userViewModel.continueRegistration(step2Data: step2Data)
        path.append("RegistrationView3")
    }
}

struct RegistrationView3: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var path: NavigationPath
    
    @State private var paymentMethod = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case paymentMethod
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Registration (3/3)")
                            .font(.custom("BeVietnamPro-Regular", size: 24))
                            .fontWeight(.bold)
                        
                        Text("See our Privacy Policy on why we gather the following information.")
                            .font(.custom("BeVietnamPro-Regular", size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            InputField(icon: "creditcard", placeholder: "Preferred Payment Method (e.g., Venmo, Zelle, Cashapp)", text: $paymentMethod)
                                .focused($focusedField, equals: .paymentMethod)
                        }
                        
                        Button(action: createAccount) {
                            Text("Create Account")
                                .font(.custom("BeVietnamPro-Regular", size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 53)
                                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            Text("Your information is secured with SSL encryption")
                                .font(.custom("BeVietnamPro-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .frame(minHeight: geometry.size.height - 60) // Subtract height of bottom link
                }
                
                bottomLink
            }
            .frame(height: geometry.size.height)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(path: $path))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    var bottomLink: some View {
        Button(action: { path = NavigationPath() }) {
            Text("Already have an account? Login ")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46)) +
            Text("here")
                .font(.custom("BeVietnamPro-Regular", size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
    
    private func createAccount() {
//        guard !paymentMethod.isEmpty else {
//            alertMessage = "Please enter your preferred payment method"
//            showingAlert = true
//            return
//        }
        
        userViewModel.finishRegistration()
        path.append("RegistrationConfirmView")
    }
}

struct RegistrationConfirmView: View {
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
                .font(.custom("BeVietnamPro-Regular", size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                path = NavigationPath()
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
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
    }
}

struct BackButton: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Button(action: {
            path.removeLast()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                Text("Back")
                    .foregroundColor(.black)
            }
        }
    }
}

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                .frame(width: 20)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(.custom("BeVietnamPro-Regular", size: 14))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.custom("BeVietnamPro-Regular", size: 14))
                }
            }
            .font(.custom("BeVietnamPro-Regular", size: 14))
            .foregroundColor(.primary)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding()
        .frame(height: 44)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .cornerRadius(8)
    }
}

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Forgot Password")
                    .font(.custom("BeVietnamPro-Regular", size: 24))
                    .fontWeight(.bold)
                
                Text("Enter your email address to reset your password")
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                InputField(icon: "envelope", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    .padding(.horizontal)
                
                Button("Reset Password") {
                    resetPassword()
                }
                .font(.custom("BeVietnamPro-Regular", size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 50)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("sent") {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
    }
    
    private func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Password reset email sent. Please check your inbox."
            }
            showingAlert = true
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
    }
}
