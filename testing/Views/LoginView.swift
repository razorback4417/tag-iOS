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
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isRegistering = false
    @State private var showingForgotPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Text("TAG")
                        .font(.custom("BeVietnamPro-Regular", size: 55))
                        .fontWeight(.heavy)
                        .italic()
                        .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                    
                    VStack(spacing: 20) {
                        InputField(icon: "envelope", placeholder: "Email", text: $email, keyboardType: .emailAddress)
                        InputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
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
                    
                    Button("Don't have an account? Register here") {
                        isRegistering = true
                    }
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .foregroundColor(Color(red: 0.06, green: 0.36, blue: 0.22))
                }
                .padding(.horizontal, 24)
            }
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isRegistering) {
                RegistrationView()
            }
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
    
    private func login() {
        userViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                // Login successful, no need to do anything as UserViewModel will update isLoggedIn
                break
            case .failure(let error):
                alertMessage = "Login failed: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

struct RegistrationView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var school = UserViewModel.School.ucla
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $name)
                    TextField("School Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Picker("School", selection: $school) {
                        ForEach(UserViewModel.School.allCases) { school in
                            Text(school.rawValue).tag(school)
                        }
                    }
                }
                
                Section(header: Text("Password")) {
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                Section {
                    Button("Register") {
                        register()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.06, green: 0.36, blue: 0.22))
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Registration")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func register() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        guard email.hasSuffix(".edu") else {
            alertMessage = "Please use a valid .edu email address"
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showingAlert = true
            return
        }
        
        userViewModel.register(name: name, email: email, school: school.rawValue, password: password) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                alertMessage = "Registration failed: \(error.localizedDescription)"
                showingAlert = true
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
                } else {
                    TextField(placeholder, text: $text)
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
