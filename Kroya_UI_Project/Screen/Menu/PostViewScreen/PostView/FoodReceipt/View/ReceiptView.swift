
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//

import SwiftUI
import Photos

struct ReceiptView: View {
    @State private var presentPopup = false  // State to control popup visibility
    @ObservedObject var viewModel = ReceiptViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Success()
                        .padding(.top, 40)
                    
                    // Pass parameters in the correct order
                    ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
                }
                .padding(.bottom, 50)
                .navigationTitle("Receipt")
                .navigationBarTitleDisplayMode(.inline)

                // Show popup if presentPopup is true
                if presentPopup {
                    Popup(isPresented: $presentPopup, dismissOnTapOutside: true) {
                        ReceiptCard1(viewModel: viewModel, presentPopup: $presentPopup)
                            .transition(.scale)  // Add a scale transition
                            .animation(.easeInOut(duration: 0.3))  // Apply the animation to the transition
                    }
                }
            }
        }
    }
}

#Preview {
    ReceiptView()
}
