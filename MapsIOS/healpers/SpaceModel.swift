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
    let lat: Double
    let lng: Double
}

func generateNearbySpaces(count: Int = 100) -> [SpaceModel] {
    var spaces: [SpaceModel] = []

    for _ in 1...count {
        let latOffset = Double.random(in: -0.8...0.8)
        let lngOffset = Double.random(in: -0.8...0.8)

        let space = SpaceModel(
            lat: baseLat + latOffset,
            lng: baseLng + lngOffset
        )
        spaces.append(space)
    }

    return spaces
}

