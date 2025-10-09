//
//  GoogleMapView.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 09/10/2025.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    
    let spaces: [SpaceModel]
    
    private let initialCameraPosition = GMSCameraPosition(
        latitude: 25.276987,
        longitude: 55.296249,
        zoom: 12.0
    )

    func makeUIView(context: Context) -> GMSMapView {
        
        let options = GMSMapViewOptions()
        options.camera = initialCameraPosition
        
        let mapView = GMSMapView(options: options)
        
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.isUserInteractionEnabled = true
        mapView.mapType = .normal
        
        // Note: setting minZoom and maxZoom to the same value (1.0) will prevent zooming completely.
        // It's usually best to remove this line or set a proper range (e.g., 1.0 to 20.0).
        // mapView.setMinZoom(1.0, maxZoom: 1.0)
        
        // 2. Loop through the data and create a marker for each space
        for space in spaces {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: space.lat, longitude: space.lng)
            
            // Set the marker title and snippet using your SpaceModel data
            marker.title = space.name
            marker.snippet = "Price: \(space.price), Distance: \(space.distance)"
            
            // Assign the marker to the map
            marker.map = mapView
            
            // Optional: You can attach the whole SpaceModel object to the marker
            // for later use (e.g., in a delegate method)
            // marker.userData = space
        }
        
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Only updates that react to SwiftUI state changes should go here.
        // Since you're not using @State or @Binding, this can remain empty.
    }
}
