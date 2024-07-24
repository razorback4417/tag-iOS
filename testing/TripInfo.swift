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
    let host: [String]  // [name, phoneNumber]
    let from: String
    let to: String
    let date: Date
    let spots: String
    let distance: String
    let price: String
}
