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
    let name: String
    let email: String
    let school: String
    var createdTrips: [String] = []
    var joinedTrips: [String] = []
}

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var userTrips: (created: [TripInfo], joined: [TripInfo]) = ([], [])
    
    private var db = Firestore.firestore()
    
    enum School: String, CaseIterable, Identifiable {
        case ucla = "UCLA"
        case usc = "USC"
        case smcc = "Santa Monica City College"
        
        var id: String { self.rawValue }
    }
    
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
    
    func register(name: String, email: String, school: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "Registration", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get user ID"])))
                return
            }
            
            let userData = User(name: name, email: email, school: school)
            self?.saveUserData(userId: userId, userData: userData) { result in
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.user = userData
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func saveUserData(userId: String, userData: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("users").document(userId).setData(from: userData)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                do {
                    self?.user = try document.data(as: User.self)
                    self?.refreshUserTrips()
                } catch {
                    print("Error decoding user data: \(error.localizedDescription)")
                }
            } else {
                print("User document does not exist")
            }
        }
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
    
    func fetchUserTrips(completion: @escaping (Result<(created: [TripInfo], joined: [TripInfo]), Error>) -> Void) {
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
    
    func fetchUserName(userId: String, completion: @escaping (String) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let name = document.get("name") as? String ?? "Unknown User"
                completion(name)
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
