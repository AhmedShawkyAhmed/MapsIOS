//
//  ContentView.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 09/10/2025.
//

import MapKit
import SwiftUI

// Apple Map with markers
//struct ContentView: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 25.276987, longitude: 55.296249),
//        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//    )
//
//    let spaces = generateNearbySpaces()
//
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: spaces) { space in
//            MapMarker(
//                coordinate: CLLocationCoordinate2D(latitude: space.lat, longitude: space.lng),
//                tint: .blue
//            )
//        }
//        .ignoresSafeArea()
//    }
//}

// Apple Map with HeatMap
//struct ContentView: View {
//    let spaces = generateNearbySpaces(count: 100)
//
//    var body: some View {
//        HeatmapView(points: spaces)
//            .ignoresSafeArea()
//    }
//}

// Google Maps with markers
//struct ContentView: View {
//    let nearbySpaces = generateNearbySpaces(count: 100)
//        
//    var body: some View {
//        GoogleMapMarkers(spaces: nearbySpaces)
//            .edgesIgnoringSafeArea(.all)
//    }
//}

// Google Maps with HeatMap
struct ContentView: View {
    let spaces = generateNearbySpaces(count: 150)
    
    var body: some View {
        GoogleHeatMap(spaces: spaces)
            .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
