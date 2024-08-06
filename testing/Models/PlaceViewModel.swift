//
//  PlaceViewModel.swift
//  testing
//
//  Created by Theo L on 8/3/24.
//

import Foundation
import SwiftUI
import MapKit

struct StructuredFormatting: Codable {
    let mainText: String
    let secondaryText: String?
    
    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case secondaryText = "secondary_text"
    }
}


class PlaceViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var places: [Place] = []
    private let apiKey = "AIzaSyBqaKYmm09G9FHCaQfjpsPnpRHEwQT9Ggo"
    
    func searchAddress(_ query: String) {
        guard let encodedText = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(apiKey)&input=\(encodedText)"
        
        guard !query.isEmpty, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.places = response.predictions.map { Place(name: $0.description, placeId: $0.placeId) }
                }
            } catch {
                print("Error decoding places: \(error)")
            }
        }.resume()
    }
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let placeId: String
}

struct GooglePlacesResponse: Codable {
    let predictions: [Prediction]
}

struct Prediction: Codable {
    let description: String
    let placeId: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case placeId = "place_id"
    }
}
