//
//  HeatmapView.swift
//  mapUI
//
//  Created by Ahmed Shawky on 08/10/2025.
//


import SwiftUI
import MapKit

struct AppleHeatMap: UIViewRepresentable {
    let points: [SpaceModel]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let worldRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: baseLat, longitude: baseLng),
            span: MKCoordinateSpan(latitudeDelta: 140, longitudeDelta: 360)
        )
        mapView.setRegion(worldRegion, animated: false)

        context.coordinator.updateOverlays(on: mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.updateOverlays(on: uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(points: points)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        let points: [SpaceModel]
        private var currentZoomScale: Double = 1.0

        init(points: [SpaceModel]) {
            self.points = points
        }

        func updateOverlays(on mapView: MKMapView) {
            mapView.removeOverlays(mapView.overlays)

            for point in points {
                let coord = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
                let radius = radiusForZoom(mapView) * point.weight
                let circle = MKCircle(center: coord, radius: radius)
                mapView.addOverlay(circle)
            }
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            updateOverlays(on: mapView)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let circle = overlay as? MKCircle else { return MKOverlayRenderer() }

            // Find the matching point
            guard let point = points.first(where: {
                abs($0.lat - circle.coordinate.latitude) < 0.0001 &&
                abs($0.lng - circle.coordinate.longitude) < 0.0001
            }) else {
                return MKOverlayRenderer()
            }

            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = heatColor(for: point.weight)
            renderer.alpha = 0.5
            return renderer
        }

        /// Change circle radius based on zoom level
        private func radiusForZoom(_ mapView: MKMapView) -> CLLocationDistance {
            let region = mapView.region
            let metersPerDegree = 111_000.0
            let visibleMeters = region.span.latitudeDelta * metersPerDegree
            let baseRadius = visibleMeters / 50.0 // Adjust this divisor for size scaling
            return max(100, min(2000, baseRadius))
        }

        /// Simple 3-color heatmap
        private func heatColor(for weight: Double) -> UIColor {
            switch weight {
            case 0.0..<0.33: return UIColor.blue.withAlphaComponent(0.7)
            case 0.33..<0.66: return UIColor.yellow.withAlphaComponent(0.7)
            default: return UIColor.red.withAlphaComponent(0.7)
            }
        }
    }
}
