//
//  TripViewModel.swift
//  testing
//
//  Created by Theo L on 7/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class TripViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var trips: [TripInfo] = []
    @Published var userTrips: [TripInfo] = []
    
    @Published var searchResults: [TripInfo] = []
    
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
                print("Error joining trip: \(error)")
            } else {
                print("Successfully joined trip")
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
    
    func deleteTrip(tripId: String, userId: String) {
        db.collection("trips").document(tripId).delete { error in
            if let error = error {
                print("Error deleting trip: \(error.localizedDescription)")
            } else {
                // Remove the trip from the user's createdTrips array
                self.db.collection("users").document(userId).updateData([
                    "createdTrips": FieldValue.arrayRemove([tripId])
                ])
                
                // Update the local trips array
                self.trips.removeAll { $0.id == tripId }
                self.fetchUserTrips(userId: userId)
                
                // Notify views that the data has changed
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func searchTrips(from: String, to: String) {
        print("TripViewModel: searchTrips called")
        print("From: '\(from)', To: '\(to)',")
        // Debug: Fetch all documents to verify data
        
        db.collection("trips").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting all documents: \(error)")
            } else {
                print("Total documents in 'trips': \(querySnapshot?.documents.count ?? 0)")
                for doc in querySnapshot?.documents ?? [] {
                    print("Document: \(doc.data())")
                }
            }
        }
        
        let query: Query = db.collection("trips")
            .whereField("from", isEqualTo: from)
            .whereField("to", isEqualTo: to)
        
        print("Executing Firestore query")
        query.getDocuments { (querySnapshot, error) in
            print("Firestore query completed")
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                if let firestoreError = error as NSError? {
                    print("Error domain: \(firestoreError.domain)")
                    print("Error code: \(firestoreError.code)")
                }
            } else {
                print("Query successful. Number of documents: \(querySnapshot?.documents.count ?? 0)")
                self.searchResults = querySnapshot?.documents.compactMap { document in
                    do {
                        var trip = try document.data(as: TripInfo.self)
                        // Ensure the document ID is set
                        trip.id = document.documentID
                        print("Decoded trip: \(trip)")
                        return trip
                    } catch {
                        print("Error decoding document: \(error)")
                        print("Document data: \(document.data())")
                        return nil
                    }
                } ?? []
                
                print("Search results updated. Count: \(self.searchResults.count)")
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }
}
