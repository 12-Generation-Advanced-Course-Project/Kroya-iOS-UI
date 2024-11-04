
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//


import SwiftUI
import Photos

struct ReceiptView: View {
    @Environment(\.dismiss) private var dismiss
    //@Binding var isPresented: Bool
    @State private var presentPopup = false
    @ObservedObject var viewModel   = ReceiptViewModel()
    @State private var isOrderReceived = false // New parameter to determine if this view is for order received
    //@State private var isOrderReceived = true

    
    var body: some View {
        
        ZStack{
            VStack {
                if isOrderReceived {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                                                   .resizable()
                                                   .frame(width: 50, height: 50)
                                                   .foregroundColor(.green)
                        Text("Receive an order") // Show this text if navigated from order
                            .font(.system(size: 22, weight: .medium))
                    
                            .padding(.top, 10)
                    }
                } else {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                                                   .resizable()
                                                   .frame(width: 50, height: 50)
                                                   .foregroundColor(.green)
                        Text("Success") // Default text
                            .font(.system(size: 22, weight: .medium))
                        
                            .padding(.top, 10)
                    }
                }
                ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
                
    // Confirm button
                Button(action: {
                    dismiss()
                }) {
                    Text("Confirm")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .padding(.bottom, 50)
            .navigationTitle("Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)  // Hide back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !presentPopup {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black)
                        }}
                }
                
            }
            // Show popup if presentPopup is true
            if presentPopup {
                Popup(isPresented: $presentPopup , dismissOnTapOutside: true) {
                    ReceiptCard1(viewModel: viewModel, presentPopup: $presentPopup)
                        .transition(.scale)  // Add a scale transition
                        .animation(.easeInOut(duration: 0.3))
                }
            }
        }
        
    }
}

#Preview {
    NavigationView {
//        ReceiptView()
    }
}
