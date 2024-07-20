//
//  TripInfo.swift
//  testing
//
//  Created by Theo L on 7/20/24.
//

import Foundation

struct TripInfo: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let date: String
    let distance: String
    let price: String
    let spots: String
    // Add any additional properties needed for TripDetailsView
}
