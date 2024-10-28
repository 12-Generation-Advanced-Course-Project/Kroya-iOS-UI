//
//  AddressView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import SwiftUI

struct AddressView: View {
    @StateObject var viewModel: AddressViewModel
    @Binding var selectedAddress: Address?
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
                                print("Update address \(address.id)")
                                addressToUpdate = address
                                showMapSheet = true
                            },
                            onDelete: {
                                print("Delete address \(address.id)")
                                viewModel.deleteAddress(id: address.id)
                            }
                        )
                    }
                    
                    Spacer()
                }
            }
            .background(Color.white)
        }
        .padding()
        .navigationBarHidden(true)
        .onDisappear {
            if let lastAddress = viewModel.addresses.last {
                selectedAddress = lastAddress
            }
        }
        .fullScreenCover(isPresented: $showMapSheet) {
            MapSelectionView(
                viewModel: viewModel,
                showMapSheet: $showMapSheet,
                addressToUpdate: addressToUpdate
            )
        }
    }
}
