import SwiftUI

struct AddressView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showMapSheet = false
    @State private var addressIdToEdit: Int? = nil // Track the address being edited
    @StateObject private var viewModel = AddressViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            if viewModel.isLoading {
                ScrollView {
                    VStack {
                        ForEach(0..<10) { _ in // Display 3 placeholder views as an example
                            AddressRowView(address: .placeholder) // Use placeholder data
                                .redacted(reason: .placeholder)
                        }
                    }
                    .padding()
                }
            } else {
                ScrollView {
                    VStack {
                        ForEach(viewModel.addresses) { address in
                            AddressRowView(
                                address: address,
                                onUpdate: {
                                    addressIdToEdit = address.id
                                    showMapSheet = true
                                },
                                onDelete: {
                                    viewModel.deleteAddress(id: address.id)
                                },
                                isDefault: address.id == viewModel.defaultAddressId
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Add button on the trailing side
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    addressIdToEdit = nil
                    locationViewModel.resetState()
                    showMapSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.yellow)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Add")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showMapSheet, onDismiss: {
            viewModel.fetchData()
        }) {
            MapSelectionView(addressIdToEdit: addressIdToEdit ,showMapSheet: $showMapSheet)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    NavigationView {
        AddressView()
    }
}

extension Address {
    static var placeholder: Address {
        Address(id: 0, addressDetail: "Loading...", specificLocation: "Loading...", tag: "Loading", latitude: 0, longitude: 0)
    }
}
