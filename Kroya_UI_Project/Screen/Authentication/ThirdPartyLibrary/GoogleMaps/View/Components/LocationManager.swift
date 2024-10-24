import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var address: String? // For current location
    @Published var pinAddress: String? // For pin location
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location.coordinate
            // Reverse geocode to get the current location address
            reverseGeocodeCurrentLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // Reverse geocode to get the full address for the current location
    func reverseGeocodeCurrentLocation(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let addressString = self?.buildFullAddress(from: placemark, coordinate: location.coordinate)
                
                DispatchQueue.main.async {
                    self?.address = addressString // Update current location address
                }
            }
        }
    }
    
    // Reverse geocode to get the full address for a pin's location
    func reverseGeocodePinLocation(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocode for pin location failed: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let addressString = self?.buildFullAddress(from: placemark, coordinate: location.coordinate)
                
                DispatchQueue.main.async {
                    self?.pinAddress = addressString // Update pin location address
                }
            }
        }
    }
    
    // Build a full address from CLPlacemark, including the building name and lat/long
    private func buildFullAddress(from placemark: CLPlacemark, coordinate: CLLocationCoordinate2D) -> String {
        var addressString = ""
        
        // Name of the building or landmark
        if let name = placemark.name {
            addressString += name
        }
        
        if let subLocality = placemark.subLocality {
            addressString += ", \(subLocality)"
        }
        if let thoroughfare = placemark.thoroughfare {
            addressString += ", \(thoroughfare)"
        }
        if let locality = placemark.locality {
            addressString += ", \(locality)"
        }
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            addressString += ", \(subAdministrativeArea)"
        }
//        if let administrativeArea = placemark.administrativeArea {
//            addressString += ", \(administrativeArea)"
//        }
        if let postalCode = placemark.postalCode {
            addressString += ", \(postalCode)"
        }
        if let country = placemark.country {
            addressString += ", \(country)"
        }
        
        // Add latitude and longitude to the address
        addressString += " (\(coordinate.latitude), \(coordinate.longitude))"
        
        return addressString
    }

}
