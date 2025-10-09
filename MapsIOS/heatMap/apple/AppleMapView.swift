//
//  AppleMapView.swift
//  mapUI
//
//  Created by Ahmed Shawky on 08/10/2025.
//

import SwiftUI
import MapKit

struct AppleMapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        
        let worldRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: baseLat, longitude: baseLng),
            span: MKCoordinateSpan(latitudeDelta: 140, longitudeDelta: 360)
        )
        mapView.setRegion(worldRegion, animated: false)
        
        // 🧭 Disable interactions
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = true
        
        // 🗺️ Set appearance
        mapView.mapType = .mutedStandard
        mapView.showsCompass = false
        
        // 🔥 Add mock heatmap
        addHeatmap(to: mapView)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No updates needed
    }
    
    // MARK: - 🔥 Generate Heatmap
    private func addHeatmap(to mapView: MKMapView) {
        for _ in 0..<300 {
            let lat = Double.random(in: -80...80)
            let lng = Double.random(in: -180...180)
            let intensity = Double.random(in: 0.3...1.0)
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let circle = MKCircle(center: coord, radius: 50000 * intensity)
            mapView.addOverlay(circle)
        }
        
        mapView.delegate = contextCoordinator(mapView)
    }
    
    // MARK: - Delegate
    private func contextCoordinator(_ mapView: MKMapView) -> MKMapDelegateCoordinator {
        let coordinator = MKMapDelegateCoordinator()
        mapView.delegate = coordinator
        return coordinator
    }
}

// MARK: - Coordinator (renders colored circles)
final class MKMapDelegateCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circle = overlay as? MKCircle else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // 🎨 Randomized heat color
        let intensity = circle.radius / 50000.0
        let color: UIColor
        switch intensity {
        case 0..<0.5:
            color = .cyan
        case 0.5..<0.8:
            color = .yellow
        default:
            color = .red
        }
        
        let renderer = MKCircleRenderer(circle: circle)
        renderer.fillColor = color.withAlphaComponent(0.4)
        renderer.strokeColor = .clear
        return renderer
    }
}
