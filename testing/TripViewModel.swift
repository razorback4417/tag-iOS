//
//  TripViewModel.swift
//  testing
//
//  Created by Theo L on 7/22/24.
//

//import Foundation
//import Firebase
//import FirebaseFirestore
//
//class TripViewModel: ObservableObject {
//    private var db = Firestore.firestore()
//    @Published var trips: [TripInfo] = []
//
//    func createTrip(_ trip: TripInfo) {
//        do {
//            _ = try db.collection("trips").addDocument(from: trip)
//        } catch {
//            print("Error creating trip: \(error.localizedDescription)")
//        }
//    }
//
//    func searchTrips(from: String, to: String, date: Date) {
//        db.collection("trips")
//            .whereField("from", isEqualTo: from)
//            .whereField("to", isEqualTo: to)
//            .whereField("date", isGreaterThanOrEqualTo: date)
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("Error getting documents: \(error)")
//                } else {
//                    self.trips = querySnapshot?.documents.compactMap { document in
//                        try? document.data(as: TripInfo.self)
//                    } ?? []
//                }
//            }
//    }
//}

import Foundation
import Firebase
import FirebaseFirestore

class TripViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    func createTrip(_ trip: TripInfo) {
        do {
            _ = try db.collection("trips").addDocument(from: trip)
        } catch {
            print("Error creating trip: \(error.localizedDescription)")
        }
    }
}
