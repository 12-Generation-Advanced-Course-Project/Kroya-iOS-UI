import Foundation
import CoreLocation
import SwiftUI

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var addressDetail: String = "Fetching address..."
    @Published var specificLocation: String = ""
    @Published var selectedTag: String?
    private var isGeocoding = false
    @Published var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation, !isGeocoding {
                reverseGeocode(location: location)
            }
            // Update latitude and longitude
            latitude = currentLocation?.coordinate.latitude ?? 0
            longitude = currentLocation?.coordinate.longitude ?? 0
        }
    }
    @Published var selectedLocation: CLLocation? {
        didSet {
            if let location = selectedLocation, !isGeocoding {
                reverseGeocode(location: location)
            }
            // Update latitude and longitude
            latitude = selectedLocation?.coordinate.latitude ?? 0
            longitude = selectedLocation?.coordinate.longitude ?? 0
        }
    }
    @Published var shouldZoomToCurrentLocation = false {
        didSet {
            if shouldZoomToCurrentLocation {
                selectedLocation = nil // Forget the selected location
                startUpdatingLocation()
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        startUpdatingLocation()
    }
    
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No locations received.")
            return
        }
        print("Current location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        currentLocation = location
        stopUpdatingLocation() // Stop updating after receiving a location to avoid continuous updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }
    
    private func reverseGeocode(location: CLLocation) {
        guard !isGeocoding else { return } // Prevent multiple simultaneous calls
        isGeocoding = true
        print("Reverse geocoding called")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            defer { self?.isGeocoding = false } // Ensure the flag is reset
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("No address found.")
                return
            }
            
            // Extract detailed address components
            let streetNumber = placemark.subThoroughfare ?? ""
            let street = placemark.thoroughfare ?? ""
            let subLocality = placemark.subLocality ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? "" // State or province
            //            let subAdministrativeArea = placemark.subAdministrativeArea ?? ""
            //            let postalCode = placemark.postalCode ?? ""
            let country = placemark.country ?? ""
            let isoCountryCode = placemark.isoCountryCode ?? ""
            
            // Create a list of address components
            let components = [
                "\(streetNumber) \(street)".trimmingCharacters(in: .whitespaces),
                subLocality,
                //                subAdministrativeArea,
                city,
                state,
                //                postalCode,
                "\(country) (\(isoCountryCode))"
            ]
            
            // Filter out empty components
            let filteredComponents = components.filter { !$0.isEmpty }
            
            // Join non-empty components with commas
            let address = filteredComponents.joined(separator: ", ")
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self?.addressDetail = address
                print("Address detail updated: \(address)")
            }
        }
    }
    
    func resetState() {
        // Reset all properties to their initial state
        addressDetail = "Fetching address..."
        specificLocation = ""
        selectedTag = nil
        latitude = 0
        longitude = 0
        selectedLocation = nil
        shouldZoomToCurrentLocation = false
    }
    
    func setFromAddress(_ address: Address) {
        self.addressDetail = address.addressDetail
        self.specificLocation = address.specificLocation
        self.selectedTag = address.tag
        self.latitude = address.latitude
        self.longitude = address.longitude
    }
    
}
