import SwiftUI
import MapKit
import Combine

struct MapSelectionView: View {
    
    var addressIdToEdit: Int?
    
    @Binding var showMapSheet: Bool
    
    @State private var sheetHeight: CGFloat = 385
    @State private var isLoading: Bool = false
    @State private var fetchError: String? = nil
    
    @StateObject private var locationViewModel = LocationViewModel()
    
    @ObservedObject private var addressViewModel = AddressViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewRepresentable(viewModel: locationViewModel)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if let id = addressIdToEdit {
                        fetchAddressDetails(id: id)
                    } else {
                        locationViewModel.shouldZoomToCurrentLocation = true
                    }
                }
            
            VStack(alignment: .trailing, spacing: 0) {
                VStack {
                    HStack {
                        Spacer()
                        CloseButton(showMapSheet: $showMapSheet)
                            .padding(.trailing)
                            .offset(y: -35)
                    }
                    Spacer()
                    ZoomToCurrentLocationButton(viewModel: locationViewModel)
                        .padding()
                }
                .frame(maxWidth: 95 ,maxHeight: .infinity)
                AddressInputView(viewModel: locationViewModel,
                                 showMapSheet: $showMapSheet,
                                 isEditing: addressIdToEdit != nil,
                                 addressId: addressIdToEdit
                )
                .padding()
                .padding(.bottom, 40)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: showMapSheet)
                .onDisappear {
                    addressViewModel.fetchAddresses()
                }
            }
            .offset(y: showMapSheet ? 40 : sheetHeight + 50)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            showMapSheet = false
                        }
                    }
            )
        }
    }
    
    private func fetchAddressDetails(id: Int) {
        isLoading = true
        addressViewModel.fetchAddressById(id: id) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let address):
                    // Populate locationViewModel with fetched address data
                    self.locationViewModel.setFromAddress(address)
                case .failure(let error):
                    self.fetchError = "Failed to load address: \(error.localizedDescription)"
                    print(self.fetchError ?? "Unknown error")
                }
            }
        }
    }
}

struct CloseButton: View {
    
    @Binding var showMapSheet: Bool
    
    var body: some View {
        Button(action: {
            showMapSheet = false
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
                .font(.system(size: 30))
        }
    }
}

struct ZoomToCurrentLocationButton: View {
    
    @ObservedObject var viewModel: LocationViewModel
    
    var body: some View {
        Button(action: {
            viewModel.shouldZoomToCurrentLocation = true
        }) {
            Image(systemName: "scope")
                .font(.system(size: 27))
                .foregroundColor(.yellow)
                .padding(10)
                .background(Circle().fill(Color.white))
                .overlay {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                }
        }
    }
}

struct AddressInputView: View {
    
    @ObservedObject var viewModel: LocationViewModel
    
    @Binding var showMapSheet: Bool
    var isEditing: Bool = false
    var addressId: Int? = nil
    
    @State private var keyboardOffset: CGFloat = 0
    @State private var validationError: String? = nil
    @State private var isLoading: Bool = false // State to track loading
    
    @StateObject private var addressViewModel = AddressViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.vertical,showsIndicators: false){
                    VStack(alignment: .leading) {
                        Text("Select your location")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.top, 5)
                        
                        HStack {
                            Image("Arrow-up-right")
                            Text(viewModel.addressDetail.isEmpty ? "Fetching address..." : viewModel.addressDetail)
                                .font(.system(size: 15))
                                .lineSpacing(3.2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Text("Address Detail")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.top, 15)
                        
                        TextField("Enter specific location", text: $viewModel.specificLocation)
                            .font(.system(size: 14))
                            .padding(.top, 5)
                        
                        Divider()
                        
                        if viewModel.specificLocation.isEmpty && validationError == "Specific location cannot be empty." {
                            Text("Specific location cannot be empty.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                                .padding(.top, 5)
                        }
                        
                        Text("Tag this location for later")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.top, 15)
                        
                        HStack(spacing: 8) {
                            ForEach(["Home", "Office", "School", "Other"], id: \.self) { tag in
                                TagButton(title: tag, isSelected: viewModel.selectedTag == tag) {
                                    viewModel.selectedTag = tag
                                }
                            }
                        }
                       
                        .padding(.top, 7)
                        
                        if let error = validationError, error == "Please select a tag for this location." {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                                .padding(.top, 5)
                        }
                        
                      
                    }
                }
                // Apply simultaneousGesture to allow ScrollView gestures and tap gestures
                .simultaneousGesture(
                    TapGesture().onEnded {
                        hideKeyboard()
                    }
                )
                .padding(.bottom, min(keyboardResponder.currentHeight, 0))
             
                Button(action: {
                    // Validation logic before sending the request
                    guard !viewModel.addressDetail.isEmpty else {
                        validationError = "Address detail cannot be empty."
                        return
                    }
                    
                    guard !viewModel.specificLocation.isEmpty else {
                        validationError = "Specific location cannot be empty."
                        return
                    }
                    
                    guard let selectedTag = viewModel.selectedTag, !selectedTag.isEmpty else {
                        validationError = "Please select a tag for this location."
                        return
                    }
                    
                    // If validation passes, reset the error and proceed
                    validationError = nil
                    isLoading = true // Start loading indicator
                    
                    if isEditing, let id = addressId {
                        // Editing logic
                        let address = Address(id: id,
                                              addressDetail: viewModel.addressDetail,
                                              specificLocation: viewModel.specificLocation,
                                              tag: selectedTag,
                                              latitude: viewModel.latitude,
                                              longitude: viewModel.longitude
                        )
                        addressViewModel.updateAddress(address) { result in
                            isLoading = false // Stop loading indicator
                            switch result {
                            case .success:
                                print("Address updated successfully")
                                showMapSheet = false
                            case .failure(let error):
                                print("Failed to update address: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        // Saving logic
                        let newAddress = Address(id: 0,
                                                 addressDetail: viewModel.addressDetail,
                                                 specificLocation: viewModel.specificLocation,
                                                 tag: selectedTag,
                                                 latitude: viewModel.latitude,
                                                 longitude: viewModel.longitude
                        )
                        addressViewModel.saveAddress(newAddress) { result in
                            isLoading = false // Stop loading indicator
                            switch result {
                            case .success:
                                print("Address saved successfully")
                                showMapSheet = false
                            case .failure(let error):
                                print("Failed to save address: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                    } else {
                        Text(isEditing ? "Update Address" : "Save Address")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.996, green: 0.801, blue: 0.011))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 5)
            }
            .ignoresSafeArea(.keyboard)
            .frame(height: .screenHeight * 0.4)
        }
    }
}

#Preview {
    MapSelectionView(showMapSheet: .constant(true))
}
