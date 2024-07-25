//
//  TripViewModel.swift
//  testing
//
//  Created by Theo L on 7/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore

//class TripViewModel: ObservableObject {
//    private var db = Firestore.firestore()
//    
//    func createTrip(_ trip: TripInfo) {
//        do {
//            _ = try db.collection("trips").addDocument(from: trip)
//        } catch {
//            print("Error creating trip: \(error.localizedDescription)")
//        }
//    }
//}

class TripViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var trips: [TripInfo] = []
    @Published var userTrips: [TripInfo] = []
    
    func createTrip(_ trip: TripInfo) {
        do {
            _ = try db.collection("trips").addDocument(from: trip)
        } catch {
            print("Error creating trip: \(error.localizedDescription)")
        }
    }
    
    func fetchAllTrips() {
        db.collection("trips").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.trips = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: TripInfo.self)
                } ?? []
            }
        }
    }
    
    func fetchUserTrips(userId: String) {
        db.collection("trips")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.userTrips = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: TripInfo.self)
                    } ?? []
                    print("Fetched \(self.userTrips.count) trips for user \(userId)")
                    
                    // Notify the view that the data has changed
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            }
    }
    
    func searchTrips(from: String, to: String, date: Date) {
        db.collection("trips")
            .whereField("from", isEqualTo: from)
            .whereField("to", isEqualTo: to)
            .whereField("date", isGreaterThanOrEqualTo: date)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.trips = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: TripInfo.self)
                    } ?? []
                }
            }
    }

    func joinTrip(tripId: String, userId: String) {
        db.collection("trips").document(tripId).updateData([
            "joinedUsers": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Error joining trip: \(error.localizedDescription)")
            } else {
                // Update user's joinedTrips array
                self.db.collection("users").document(userId).updateData([
                    "joinedTrips": FieldValue.arrayUnion([tripId])
                ])
                self.fetchAllTrips()
                self.fetchUserTrips(userId: userId)
            }
        }
    }
    
    func leaveTrip(tripId: String, userId: String) {
        db.collection("trips").document(tripId).updateData([
            "joinedUsers": FieldValue.arrayRemove([userId])
        ]) { error in
            if let error = error {
                print("Error leaving trip: \(error.localizedDescription)")
            } else {
                // Update user's joinedTrips array
                self.db.collection("users").document(userId).updateData([
                    "joinedTrips": FieldValue.arrayRemove([tripId])
                ])
                self.fetchAllTrips()
                self.fetchUserTrips(userId: userId)
            }
        }
    }
    
}
