import SwiftUI
import GoogleMaps

struct MapSelectionView: View {
    
    @State var viewModel: AddressViewModel
    @Binding var showMapSheet: Bool
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 11.5449, longitude: 104.8922)
    @State private var markerCoordinate: CLLocationCoordinate2D? // To track where the marker is dropped
    @State private var addressDetail = ""
    @State private var selectedTag: String?
    
    @ObservedObject private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                GoogleMapViewRepresentable(centerCoordinate: $centerCoordinate, markerCoordinate: $markerCoordinate, locationManager: locationManager)
                    .edgesIgnoringSafeArea(.all)

                Button(action: {
                    showMapSheet = false // Close the map view
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                        .padding()
                }

                // Use a VStack to move the button to the bottom center of the map
                VStack {
                    Spacer()

                    // Custom "My Location" button styled like the one in the image
                    Button(action: {
                        if let location = locationManager.location {
                            // Remove marker when getting the current location
                            markerCoordinate = nil

                            // Update the centerCoordinate to the user's current location
                            centerCoordinate = location
                            
                            // Reverse geocode for the current location's address
                            locationManager.reverseGeocodeCurrentLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
                            
                            // Zoom in on the current location
                            let zoomLevel: Float = 18.0
                            let cameraUpdate = GMSCameraUpdate.setTarget(location, zoom: zoomLevel)
                            if let mapView = UIApplication.shared.windows.first?.rootViewController?.view as? GMSMapView {
                                mapView.animate(with: cameraUpdate)
                            }
                        }
                    }) {
                        Image(systemName: "scope")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                            .foregroundColor(.yellow)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    }
                    .frame(width: 37, height: 37)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 55)
                }
            }
            .offset(y: 30)

            VStack(alignment: .leading) {
                Text("Select your location")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .opacity(0.84)
                    .padding(.top, 10)

                HStack {
                    Image(.arrowUpRight)
                    Text(markerCoordinate != nil ? (locationManager.pinAddress?.components(separatedBy: " (").first ?? "Finding pin address...") : (locationManager.address?.components(separatedBy: " (").first ?? "Finding current address..."))
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                }
                .onTapGesture {
                    if let coordinate = markerCoordinate ?? locationManager.location {
                        openInGoogleMaps(coordinate: coordinate)
                    }
                }

                Text("Address Detail")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                    .opacity(0.84)
                    .padding(.top, 15)

                TextField("Address Detail", text: $addressDetail)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.gray)
                    .padding(.top, 5)

                Divider()

                Text("Tag this location for later")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                    .opacity(0.84)
                    .padding(.top, 15)

                HStack(spacing: 5) {
                    TagButton(title: "Home", isSelected: selectedTag == "Home") {
                        selectedTag = "Home"
                    }

                    TagButton(title: "Office", isSelected: selectedTag == "Office") {
                        selectedTag = "Office"
                    }

                    TagButton(title: "School", isSelected: selectedTag == "School") {
                        selectedTag = "School"
                    }

                    TagButton(title: "Other", isSelected: selectedTag == "Other") {
                        selectedTag = "Other"
                    }
                }
                .padding(.top, 7)

                Button(action: {
                    viewModel.addNewAddress(
                        addressDetail: addressDetail,
                        specificLocation: markerCoordinate != nil ? locationManager.pinAddress ?? "" : locationManager.address ?? "",
                        tag: selectedTag ?? "Other"
                    )
                    showMapSheet = false // Close the sheet after saving
                }) {
                    Text("Save Address")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.996, green: 0.801, blue: 0.011))
                        .cornerRadius(10)
                }
                .padding(.top, 25)
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // Function to open the location in Google Maps app
    func openInGoogleMaps(coordinate: CLLocationCoordinate2D) {
        let url = "comgooglemaps://?q=\(coordinate.latitude),\(coordinate.longitude)"
        if let googleMapsURL = URL(string: url), UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL)
        } else {
            // Fallback to open Google Maps in the browser if the app is not installed
            let browserURL = "https://www.google.com/maps/search/?api=1&query=\(coordinate.latitude),\(coordinate.longitude)"
            if let url = URL(string: browserURL) {
                UIApplication.shared.open(url)
            }
        }
    }
}

//#Preview {
//    MapSelectionView(viewModel: AddressViewModel(), showMapSheet: .constant(true))
//}
