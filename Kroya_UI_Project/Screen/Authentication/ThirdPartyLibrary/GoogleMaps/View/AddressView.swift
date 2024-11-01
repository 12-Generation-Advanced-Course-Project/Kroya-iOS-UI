//
//  AddressView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var viewModel: AddressViewModel
    @State private var showMapSheet = false
    @State private var addressToUpdate: Address?
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAddressID: Int?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .opacity(0.84)
                }
                Spacer()
                Text("My Address")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                    .opacity(0.84)
                Spacer()
                Button(action: {
                    addressToUpdate = nil
                    showMapSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(PrimaryColor.normal)
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                        Text("Add")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.black)
                            .opacity(0.84)
                    }
                }
            }
            .padding(.bottom)

            ScrollView {
                VStack {
                    Divider()
                    ForEach(viewModel.addresses) { address in
                        Button(action: {
                            viewModel.selectedAddress = address
                            selectedAddressID = address.id // Update selected address ID
                            dismiss()
                        }) {
                            AddressRowView(
                                address: address,
                                onUpdate: {
                                    addressToUpdate = address
                                    showMapSheet = true
                                },
                                onDelete: {
                                    viewModel.deleteAddress(id: address.id)
                                },
                                isSelected: address.id == selectedAddressID // Highlight if selected
                            )
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchAllAddresses()
            // Initialize selected address highlight if a selection exists
            selectedAddressID = viewModel.selectedAddress?.id
        }
        .fullScreenCover(isPresented: $showMapSheet, onDismiss: {
            viewModel.fetchAllAddresses()
        }) {
            MapSelectionView(
                viewModel: viewModel,
                showMapSheet: $showMapSheet,
                addressToUpdate: addressToUpdate
            )
        }
    }
}
