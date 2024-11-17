import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: LocationViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        // Add tap gesture recognizer to select a location on the map
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if viewModel.shouldZoomToCurrentLocation, let userLocation = viewModel.currentLocation {
            // Clear any existing pins when zooming to the current location
            uiView.removeAnnotations(uiView.annotations)
            
            // Center the map on the current location
            centerMap(on: userLocation, for: uiView, zoomLevel: 0.005, animated: true)
            DispatchQueue.main.async {
                viewModel.shouldZoomToCurrentLocation = false
            }
        }
        //** Handle case for new coordinates from latitude and longitude
        else if viewModel.latitude != 0 && viewModel.longitude != 0 {
            let location = CLLocation(latitude: viewModel.latitude, longitude: viewModel.longitude)
            centerMap(on: location, for: uiView, zoomLevel: 0.005, animated: true)
            addPin(to: uiView, at: location.coordinate)
        }
        else if let selectedLocation = viewModel.selectedLocation {
            // Center and add a pin annotation at the selected location
            centerMap(on: selectedLocation, for: uiView, zoomLevel: 0.005, animated: true)
            addPin(to: uiView, at: selectedLocation.coordinate)
        }
    }
    
    private func centerMap(on location: CLLocation, for mapView: MKMapView, zoomLevel: Double, animated: Bool) {
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        )
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                mapView.setRegion(region, animated: true)
            }, completion: nil)
        } else {
            mapView.setRegion(region, animated: false)
        }
    }
    
    private func addPin(to mapView: MKMapView, at coordinate: CLLocationCoordinate2D) {
        // Remove existing annotations (optional, to avoid multiple pins)
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        @objc func handleMapTap(gesture: UITapGestureRecognizer) {
            let locationInView = gesture.location(in: gesture.view)
            if let mapView = gesture.view as? MKMapView {
                let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
                let selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                parent.viewModel.selectedLocation = selectedLocation
                print("Selected location: \(coordinate.latitude), \(coordinate.longitude)")
                
                // Add a pin at the selected location
                parent.addPin(to: mapView, at: coordinate)
            }
        }
    }
}
