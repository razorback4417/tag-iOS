//
//  TripViewModel.swift
//  testing
//
//  Created by Theo L on 7/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation

class TripViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var trips: [TripInfo] = []
    @Published var userTrips: [TripInfo] = []
    
    @Published var searchResults: [TripInfo] = []
    
    @Published var pastTrips: [TripInfo] = []
    
    func createTrip(_ trip: TripInfo) {
        let fromCoord = CLLocation(latitude: trip.fromLatitude, longitude: trip.fromLongitude)
        let toCoord = CLLocation(latitude: trip.toLatitude, longitude: trip.toLongitude)
        
        let distanceInMeters = fromCoord.distance(from: toCoord)
        let distanceInMiles = distanceInMeters / 1609.34
        let roundedDistance = round(distanceInMiles * 10) / 10  // Round to nearest tenth
        
        var updatedTrip = trip
        updatedTrip.distance = roundedDistance
        
        do {
            _ = try db.collection("trips").addDocument(from: updatedTrip)
        } catch {
            print("Error creating trip: \(error.localizedDescription)")
        }
    }
    
    func fetchAllTrips() {
        let currentDate = Date()
        db.collection("trips")
            .whereField("date", isGreaterThanOrEqualTo: currentDate)
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
    
    //note to self: add index at the https://console.firebase.google.com/
    /*
     from - as
     to - as
     date - as
     __name__ - as
     
     -------
     
     joinedUsers - arrays
     date - des
     __name__ - des
     */
    func fetchPastTrips(for userId: String) {
        print("in past trips")
        let db = Firestore.firestore()
        db.collection("trips")
            .whereField("joinedUsers", arrayContains: userId)
            .whereField("date", isLessThan: Date())
            .order(by: "date", descending: true)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching past trips: \(error)")
                    return
                }
                
                self.pastTrips = snapshot?.documents.compactMap { document -> TripInfo? in
                    try? document.data(as: TripInfo.self)
                } ?? []
            }
    }
    
    func searchTrips(from: String, to: String, date: Date) {
        let currentDate = Date()
        let query = db.collection("trips")
            .whereField("from", isEqualTo: from)
            .whereField("to", isEqualTo: to)
            .whereField("date", isGreaterThanOrEqualTo: currentDate)

        query.getDocuments { (querySnapshot, error) in
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
        print("From: '\(from)', To: '\(to)'")
        
        // Get coordinates for the 'from' and 'to' locations
        getCoordinates(for: from) { fromCoordinates in
            self.getCoordinates(for: to) { toCoordinates in
                guard let fromCoord = fromCoordinates, let toCoord = toCoordinates else {
                    print("Could not get coordinates for locations")
                    return
                }
                
                let query = self.db.collection("trips")
                query.getDocuments(source: .default) { (querySnapshot, error) in
                    if let error = error {
                        print("Firestore error: \(error.localizedDescription)")
                    } else {
                        self.searchResults = querySnapshot?.documents.compactMap { document in
                            do {
                                var trip = try document.data(as: TripInfo.self)
                                let tripFromCoord = CLLocation(latitude: trip.fromLatitude, longitude: trip.fromLongitude)
                                let tripToCoord = CLLocation(latitude: trip.toLatitude, longitude: trip.toLongitude)
                                
                                let fromDistance = fromCoord.distance(from: tripFromCoord) / 1609.34 // Convert to miles
                                let toDistance = toCoord.distance(from: tripToCoord) / 1609.34 // Convert to miles
                                
                                if fromDistance <= 2 && toDistance <= 2 {
                                    trip.id = document.documentID
                                    return trip
                                }
                                return nil
                            } catch {
                                print("Error decoding document: \(error)")
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
    }
    
    private func getCoordinates(for address: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let location = placemarks?.first?.location else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
}
