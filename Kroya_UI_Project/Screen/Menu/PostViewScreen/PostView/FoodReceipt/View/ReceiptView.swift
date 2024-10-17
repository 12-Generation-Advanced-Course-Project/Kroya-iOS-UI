
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
            ZStack { // Use ZStack to overlay the popup
                VStack {
                    Success()
                        .padding(.top, 40)
                    
                    ReceiptCard(presentPopup: $presentPopup)
                }
                .padding(.bottom, 50)
                .navigationTitle("Receipt")
                .navigationBarTitleDisplayMode(.inline)
                
                // Show the Popup when `presentPopup` is true
                if presentPopup {
                    Popup(isPresented: $presentPopup) {
                        ReceiptCard(presentPopup: $presentPopup) // Or another relevant view for the popup
                        
                    }
                }
            }
        }
    }
}


#Preview {
    ReceiptView()
}
