
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//

import UIKit
import Photos
import SwiftUI
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
                        ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
                    }
                }
            }
        }
    }
}
