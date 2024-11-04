
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//


import SwiftUI
import Photos

struct ReceiptView: View {
    @Environment(\.dismiss) private var dismiss // This will dismiss only the ReceiptView
    @Binding var isPresented: Bool
    @State private var presentPopup = false  // State to control popup visibility
    @ObservedObject var viewModel   = ReceiptViewModel()

    var body: some View {
        
        ZStack{
            VStack {
                Success()
                ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup )
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
                        .animation(.easeInOut(duration: 0.3))  // Apply the animation to the transition
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
