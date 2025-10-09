//
//  SpaceModel.swift
//  mapUI
//
//  Created by Ahmed Shawky on 08/10/2025.
//

import Foundation
import CoreLocation


let baseLat = 25.276987
let baseLng = 55.296249

struct SpaceModel: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let status: String
    let views: Int
    let weight: Double
    let distance: String
    let lat: Double
    let lng: Double
}

func generateNearbySpaces(count: Int = 100) -> [SpaceModel] {
    var spaces: [SpaceModel] = []

    for i in 1...count {
        // Slightly larger offset range → more spread out points
        // ±0.08 degrees ≈ ~9km north/south, ~7km east/west around base
        let latOffset = Double.random(in: -0.8...0.8)
        let lngOffset = Double.random(in: -0.8...0.8)
        let weight = Double.random(in: 0.3...1.0) // avoid too small weights

        let space = SpaceModel(
            name: "Space \(i)",
            price: "\(Double.random(in: 5...15)) ريال",
            status: "\(Int.random(in: 1...3))",
            views: Int.random(in: 100...5000),
            weight: weight,
            distance: String(format: "%.1f كم", Double.random(in: 1...15)),
            lat: baseLat + latOffset,
            lng: baseLng + lngOffset
        )
        spaces.append(space)
    }

    return spaces
}

