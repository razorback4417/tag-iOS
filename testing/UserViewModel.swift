//
//  UserViewModel.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//
import Foundation
import Firebase
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let phoneNumber: String
    let gender: String
    let school: String
    let major: String
    let interests: [String]
}

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var registrationData: RegistrationData?
    
    private var db = Firestore.firestore()
    
    init() {
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            self.isLoggedIn = true
            fetchUserData(userId: user.uid)
        } else {
            self.isLoggedIn = false
            self.user = nil
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            
            self.isLoggedIn = true
            if let userId = result?.user.uid {
                self.fetchUserData(userId: userId)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func startRegistration(step1Data: RegistrationStep1Data) {
        registrationData = RegistrationData(step1: step1Data)
    }
    
    func continueRegistration(step2Data: RegistrationStep2Data) {
        registrationData?.step2 = step2Data
    }
    
    func finishRegistration() {
        
        guard let registrationData = registrationData,
              let step1 = registrationData.step1,
              let step2 = registrationData.step2 else {
            print("Registration data is incomplete")
            return
        }
        
        let userData = User(
            firstName: step1.name,
            lastName: step1.surname,
            email: step1.email,
            username: step1.username,
            phoneNumber: step1.phone,
            gender: step2.gender,
            school: step2.school,
            major: step2.major,
            interests: step2.interests.components(separatedBy: ",")
        )
        
        Auth.auth().createUser(withEmail: step1.email, password: step1.password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }
            
            guard let userId = result?.user.uid else { return }
            
            self.saveUserData(userId: userId, userData: userData)
        }
    }
    
    func saveUserData(userId: String, userData: User) {
        do {
            try db.collection("users").document(userId).setData(from: userData, merge: true)
            self.user = userData
            self.isLoggedIn = true
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self)
                    print("Fetched user data: \(String(describing: self.user))")
                } catch {
                    print("Error decoding user data: \(error.localizedDescription)")
                }
            } else {
                print("User document does not exist")
            }
        }
    }
    
    func updateUserData(userData: User) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try db.collection("users").document(userId).setData(from: userData, merge: true)
            self.user = userData
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
        }
    }
}

struct RegistrationData {
    var step1: RegistrationStep1Data?
    var step2: RegistrationStep2Data?
}

struct RegistrationStep1Data {
    let name: String
    let surname: String
    let email: String
    let username: String
    let phone: String
    let password: String
}

struct RegistrationStep2Data {
    let gender: String
    let major: String
    let school: String
    let interests: String
}
