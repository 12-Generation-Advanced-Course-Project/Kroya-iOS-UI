
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//

import SwiftUI

struct ReceiptView: View {
    
    @State private var presentPopup = false
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
                
                if presentPopup {
                    Popup(isPresented: $presentPopup) {
                        // Display the receipt details within the popup
                        ReceiptCard(viewModel: viewModel, presentPopup: $presentPopup)
                    }
                }
            }
        }
    }
}


#Preview {
    ReceiptView()
}
