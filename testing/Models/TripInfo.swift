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
    var distance: Double //dont worry about
    let price: String //dont worry about
    let fromLatitude: Double
    let fromLongitude: Double
    let toLatitude: Double
    let toLongitude: Double
    let isPrivate: Bool
    let inviteCode: String?
    
    var availableSpots: Int {
        return totalSpots - joinedUsers.count
    }
    
    var spots: String {
        return "\(joinedUsers.count)/\(totalSpots) spots"
    }
}
