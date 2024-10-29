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
    @State private var addressToUpdate: Address? = nil
    @Environment(\.dismiss) private var dismiss

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
            }
            .padding(.bottom)

            HStack {
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
                        AddressRowView(
                            address: address,
                            onUpdate: {
                                print("Attempting to update address with ID \(address.id)")
                                addressToUpdate = address
                                showMapSheet = true
                                // Removed fetchAllAddresses to prevent interference
                            },
                            onDelete: {
                                print("Deleting address with ID \(address.id)")
                                viewModel.deleteAddress(id: address.id)
                            }
                        )
                    }
                    
                    Spacer()
                }
            }

        }
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchAllAddresses()
        }
        .onDisappear {
            if let lastAddress = viewModel.addresses.last {
                viewModel.selectedAddress = lastAddress
            }
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
