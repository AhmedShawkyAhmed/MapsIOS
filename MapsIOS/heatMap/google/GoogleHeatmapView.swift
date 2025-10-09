//
//  GoogleMapView.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 09/10/2025.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct GoogleHeatmapView: UIViewRepresentable {
    let spaces: [SpaceModel]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private let initialCameraPosition = GMSCameraPosition(
        latitude: baseLat,
        longitude: baseLng,
        zoom: 12.0
    )

    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = initialCameraPosition
        
        let mapView = GMSMapView(options: options)
        mapView.delegate = context.coordinator
        
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.mapType = .normal
        mapView.setMinZoom(5.0, maxZoom: 25.0)
        
        // Add initial heatmap
        context.coordinator.addHeatmap(to: mapView, with: spaces)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        context.coordinator.updateHeatmap(uiView, with: spaces)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleHeatmapView
        private var heatmapLayer: GMUHeatmapTileLayer?

        init(_ parent: GoogleHeatmapView) {
            self.parent = parent
        }

        func addHeatmap(to mapView: GMSMapView, with data: [SpaceModel]) {
            // Remove previous heatmap if it exists
            heatmapLayer?.map = nil

            let layer = GMUHeatmapTileLayer()
            layer.opacity = 0.9
            layer.radius = 150
            layer.gradient = createGradient()
            layer.weightedData = convertDataToPoints(data)
            layer.map = mapView

            self.heatmapLayer = layer
        }

        func updateHeatmap(_ mapView: GMSMapView, with data: [SpaceModel]) {
            addHeatmap(to: mapView, with: data)
        }

        private func createGradient() -> GMUGradient {
            let colors = [
                UIColor.blue,
                UIColor.yellow,
                UIColor.red
            ]
            let startPoints: [NSNumber] = [0.2, 0.5, 1.0]
            return GMUGradient(colors: colors, startPoints: startPoints, colorMapSize: 256)
        }

        private func convertDataToPoints(_ data: [SpaceModel]) -> [GMUWeightedLatLng] {
            return data.map {
                let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)
                return GMUWeightedLatLng(coordinate: coordinate, intensity: Float($0.weight))
            }
        }

        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            guard let heatmapLayer = heatmapLayer else { return }
            
            let zoom = position.zoom
            let baseRadius: CGFloat = 150
            // Keep radius visually consistent with zoom
            let adjustedRadius = max(10, baseRadius * (1 / CGFloat(pow(2, zoom / 10))))
            
            heatmapLayer.radius = UInt(adjustedRadius)
            heatmapLayer.clearTileCache()
        }
    }
}

