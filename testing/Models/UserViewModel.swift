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
    var createdTrips: [String] = []  // Array of trip IDs created by the user
    var joinedTrips: [String] = []   // Array of trip IDs joined by the user
}
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var registrationData: RegistrationData?
    private var db = Firestore.firestore()
    
    @Published var userTrips: (created: [TripInfo], joined: [TripInfo]) = ([], [])
    
    init() {
        checkUserStatus()
    }
    
    func refreshUserTrips() {
        fetchUserTrips { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trips):
                    self?.userTrips = trips
                    self?.objectWillChange.send()
                case .failure(let error):
                    print("Failed to refresh user trips: \(error.localizedDescription)")
                }
            }
        }
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
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.isLoggedIn = true
                if let userId = result?.user.uid {
                    self?.fetchUserData(userId: userId)
                }
                completion(.success(()))
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
        print("here inside fetch")
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
    //    RYNfFRXhsfYPfKlIhpYXWI286TM2
    
    func updateUserData(userData: User) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try db.collection("users").document(userId).setData(from: userData, merge: true)
            self.user = userData
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
        }
    }
    
    
    func fetchUserTrips(completion: @escaping (Result<(created: [TripInfo], joined: [TripInfo]), Error>) -> Void) {
        print("fetching user trips")
        guard let user = self.user, let userId = user.id else {
            completion(.failure(NSError(domain: "UserViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in or user data not available"])))
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var createdTrips: [TripInfo] = []
        var joinedTrips: [TripInfo] = []
        var fetchError: Error?
        
        dispatchGroup.enter()
        self.fetchTrips(ids: user.createdTrips) { result in
            switch result {
            case .success(let trips):
                createdTrips = trips
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.fetchTrips(ids: user.joinedTrips) { result in
            switch result {
            case .success(let trips):
                joinedTrips = trips
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                let result = (created: createdTrips, joined: joinedTrips)
                completion(.success(result))
            }
        }
    }
    
    private func fetchTrips(ids: [String], completion: @escaping (Result<[TripInfo], Error>) -> Void) {
        let group = DispatchGroup()
        var trips: [TripInfo] = []
        var fetchError: Error?
        
        for id in ids {
            group.enter()
            db.collection("trips").document(id).getDocument { (document, error) in
                if let error = error {
                    fetchError = error
                } else if let document = document, document.exists,
                          let trip = try? document.data(as: TripInfo.self) {
                    trips.append(trip)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(trips))
            }
        }
    }
}

extension UserViewModel {
    func fetchUserName(userId: String, completion: @escaping (String) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let firstName = document.get("firstName") as? String ?? ""
                let lastName = document.get("lastName") as? String ?? ""
                completion("\(firstName) \(lastName)")
            } else {
                completion("Unknown User")
            }
        }
    }
    
    func fetchUserNames(userIds: [String], completion: @escaping ([String]) -> Void) {
        let group = DispatchGroup()
        var names: [String] = []
        
        for userId in userIds {
            group.enter()
            fetchUserName(userId: userId) { name in
                names.append(name)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(names)
        }
    }
    
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "UserViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        let userId = user.uid
        
        // Delete user data from Firestore
        db.collection("users").document(userId).delete { [weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Delete user authentication
            user.delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self?.signOut()
                    completion(.success(()))
                }
            }
        }
    }
}

extension UserViewModel {
    func fetchUserProfile(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "UserViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
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
