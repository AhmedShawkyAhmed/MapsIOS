//
//  SpaceModel.swift
//  mapUI
//
//  Created by Ahmed Shawky on 08/10/2025.
//


import Foundation
import CoreLocation

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
    let baseLat = 25.276987   // e.g. Dubai
    let baseLng = 55.296249
    var spaces: [SpaceModel] = []

    for i in 1...count {
        let latOffset = Double.random(in: -0.02...0.02)
        let lngOffset = Double.random(in: -0.02...0.02)
        let weight = Double.random(in: 0.0...1.0)

        let space = SpaceModel(
            name: "Space \(i)",
            price: "\(Double.random(in: 5...15)) ريال",
            status: "\(Int.random(in: 1...3))",
            views: Int.random(in: 100...5000),
            weight: weight,
            distance: String(format: "%.1f كم", Double.random(in: 0.5...10)),
            lat: baseLat + latOffset,
            lng: baseLng + lngOffset
        )
        spaces.append(space)
    }

    return spaces
}

