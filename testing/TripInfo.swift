//
//  TripInfo.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import Foundation
import FirebaseFirestoreSwift

struct TripInfo: Identifiable, Codable {
    @DocumentID var id: String?
    let hostId: String
    let from: String
    let to: String
    let date: Date
    var joinedUsers: [String]
    let totalSpots: Int
    let distance: String
    let price: String
    
    var availableSpots: Int {
        return totalSpots - joinedUsers.count
    }
    
    var spots: String {
        return "\(joinedUsers.count + 1)/\(totalSpots) spots"
    }
}
