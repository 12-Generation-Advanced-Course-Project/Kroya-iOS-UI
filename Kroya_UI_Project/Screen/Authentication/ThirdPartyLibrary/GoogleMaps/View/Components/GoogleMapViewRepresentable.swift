import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapViewRepresentable: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var markerCoordinate: CLLocationCoordinate2D? // Binding for the marker location
    var locationManager: LocationManager // Pass the LocationManager to update the address for pin
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: centerCoordinate.latitude,
            longitude: centerCoordinate.longitude,
            zoom: 15.0
        )
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator // Set the map delegate to handle events

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let cameraUpdate = GMSCameraUpdate.setTarget(centerCoordinate)
        mapView.animate(with: cameraUpdate)

        // Add or update the marker based on the markerCoordinate
        if let markerCoordinate = markerCoordinate {
            if let marker = context.coordinator.marker {
                marker.position = markerCoordinate
            } else {
                let newMarker = GMSMarker(position: markerCoordinate)
                newMarker.map = mapView
                context.coordinator.marker = newMarker
            }
        } else {
            context.coordinator.marker?.map = nil
            context.coordinator.marker = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, locationManager: locationManager)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapViewRepresentable
        var marker: GMSMarker?
        var locationManager: LocationManager
        
        init(_ parent: GoogleMapViewRepresentable, locationManager: LocationManager) {
            self.parent = parent
            self.locationManager = locationManager
        }
        
        // Handle map tap to add marker
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            // Set the marker at the tapped location
            parent.markerCoordinate = coordinate
            parent.centerCoordinate = coordinate
            
            // Get the address of the tapped location
            locationManager.reverseGeocodePinLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
           
            // Zoom into the pin's location (closer zoom level)
            let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: 18.0)
            mapView.animate(with: cameraUpdate)
        }

        // Handle marker tap to remove the marker
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            // Remove the marker from the map
            parent.markerCoordinate = nil
            return true
        }
    }
}
