import SwiftUI
import GoogleMaps

struct MapSelectionView: View {
    @ObservedObject var viewModel: AddressViewModel
    @Binding var showMapSheet: Bool
    var addressToUpdate: Address?
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 11.5449, longitude: 104.8922)
    @State private var markerCoordinate: CLLocationCoordinate2D? = nil
    @State private var addressDetail = ""
    @State private var selectedTag: String? = nil
    @ObservedObject private var locationManager = LocationManager()
    @Environment(\.dismiss) var dismiss
    @State private var isLoadingAddress = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    GoogleMapViewRepresentable(
                        centerCoordinate: $centerCoordinate,
                        markerCoordinate: $markerCoordinate,
                        locationManager: locationManager
                    )
                    .edgesIgnoringSafeArea(.all)

                    // UI for navigation and controls
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Button(action: { showMapSheet = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 30))
                                .padding()
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)

                    // Current location button
                    VStack {
                        Spacer()
                        Button(action: {
                            if let location = locationManager.location {
                                markerCoordinate = nil
                                centerCoordinate = location
                                locationManager.reverseGeocodeCurrentLocation(
                                    CLLocation(latitude: location.latitude, longitude: location.longitude)
                                )
                            }
                        }) {
                            Image(systemName: "scope")
                                .font(.system(size: 24))
                                .foregroundColor(.yellow)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 55)
                    }
                }
                .onAppear {
                    // Load address to update if available
                    if let address = addressToUpdate {
                        updateCoordinatesAndTriggerReverseGeocoding(from: address)
                    }
                }
                .onChange(of: addressToUpdate) { newAddress in
                    // Trigger geocoding if address changes
                    if let newAddress = newAddress {
                        updateCoordinatesAndTriggerReverseGeocoding(from: newAddress)
                    }
                }

                // Display and input fields
                VStack(alignment: .leading) {
                    Text("Select your location")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.top, 10)

                    // Display the fetched or updated location
                    HStack {
                        Image(.arrowUpRight)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                        Text(markerCoordinate != nil ? locationManager.pinAddress ?? "Finding pin address..." : locationManager.address ?? "Finding current address...")
                            .font(.system(size: 15, weight: .regular))
                    }
                    .onTapGesture {
                        if let coordinate = markerCoordinate ?? locationManager.location {
                            openInGoogleMaps(coordinate: coordinate)
                        }
                    }

                    // Address detail and tag fields
                    Text("Address Detail")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.top, 15)
                    TextField("Address Detail", text: $addressDetail)
                        .font(.system(size: 14))
                        .padding(.top, 5)
                    Divider()
                    Text("Tag this location for later")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.top, 15)

                    HStack(spacing: 5) {
                        TagButton(title: "Home", isSelected: selectedTag == "Home") { selectedTag = "Home" }
                        TagButton(title: "Office", isSelected: selectedTag == "Office") { selectedTag = "Office" }
                        TagButton(title: "School", isSelected: selectedTag == "School") { selectedTag = "School" }
                        TagButton(title: "Other", isSelected: selectedTag == "Other") { selectedTag = "Other" }
                    }

                    // Save or Update button
                    Button(action: saveOrUpdateAddress) {
                        Text("Save Address")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                    .padding(.top, 25)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Function to update coordinates and start reverse geocoding
    private func updateCoordinatesAndTriggerReverseGeocoding(from address: Address) {
        centerCoordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        markerCoordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        addressDetail = address.addressDetail
        selectedTag = address.tag
        
        isLoadingAddress = true
        locationManager.reverseGeocodePinLocation(
            CLLocation(latitude: address.latitude, longitude: address.longitude)
        ) {
            isLoadingAddress = false
        }
    }

    // Save or update address based on whether it's an edit or a new address
    private func saveOrUpdateAddress() {
        guard let markerCoordinate = markerCoordinate else { return }
        
        if let addressToUpdate = addressToUpdate {
            let updatedAddress = Address(
                id: addressToUpdate.id,
                addressDetail: addressDetail.isEmpty ? addressToUpdate.addressDetail : addressDetail,
                specificLocation: locationManager.pinAddress ?? addressToUpdate.specificLocation,
                tag: selectedTag ?? addressToUpdate.tag,
                latitude: markerCoordinate.latitude,
                longitude: markerCoordinate.longitude
            )
            viewModel.updateAddress(id: addressToUpdate.id, address: updatedAddress)
        } else {
            viewModel.saveAddress(
                addressDetail: addressDetail,
                specificLocation: locationManager.pinAddress ?? "No address found",
                tag: selectedTag ?? "Other",
                latitude: markerCoordinate.latitude,
                longitude: markerCoordinate.longitude
            )
        }
        showMapSheet = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
        }
    }

    // Function to open coordinates in Google Maps
    func openInGoogleMaps(coordinate: CLLocationCoordinate2D) {
        let url = "comgooglemaps://?q=\(coordinate.latitude),\(coordinate.longitude)"
        if let googleMapsURL = URL(string: url), UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL)
        } else {
            let browserURL = "https://www.google.com/maps/search/?api=1&query=\(coordinate.latitude),\(coordinate.longitude)"
            if let url = URL(string: browserURL) {
                UIApplication.shared.open(url)
            }
        }
    }
}

